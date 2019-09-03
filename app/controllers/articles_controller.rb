# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :signed_in?, only: %i[new create edit update destroy]

  def index
    @route = if params[:year].to_i == 0 && params[:month].to_i == 0
               true
             else
               false
             end

    # rootにアクセスしたときは@yearは今年
    @year = params[:year].to_i
    if @year === 0
      @year = (Time.now.in_time_zone('Tokyo') - 3600 * 5).strftime('%Y').to_i
    end

    # rootにアクセスしたときは@monthは今月
    @month = params[:month].to_i
    if @month === 0
      @month = (Time.now.in_time_zone('Tokyo') - 3600 * 5).strftime('%m').to_i
    end

    @articles = Article.order('day').where(year: @year).where(month: @month)
  end

  def show
    year  = params[:year].to_i
    month = params[:month].to_i
    day   = params[:day].to_i

    @article = Article.find_by!(year: year, month: month, day: day)

    @prev_article = Article.select('year, month, day').where('date < ?', @article.date).order('date DESC').first
    @next_article = Article.select('year, month, day').where('date > ?', @article.date).order('date ASC').first
  end

  def new
    year  = (Time.now.in_time_zone('Tokyo') - 3600 * 5).strftime('%Y').to_i
    month = (Time.now.in_time_zone('Tokyo') - 3600 * 5).strftime('%m').to_i
    day   = (Time.now.in_time_zone('Tokyo') - 3600 * 5).strftime('%d').to_i
    article = Article.find_by(year: year, month: month, day: day)

    @templates = Template.all

    if article
      redirect_to root_path, notice: 'Already published today!'
      return
    end

    @article = Article.new
    @article.templated_articles.build
    @post_url = '/new'
  end

  def create
    @article = Article.new(article_and_templated_articles_params)

    @article.year  = (Time.now.in_time_zone('Tokyo') - 3600 * 5).strftime('%Y').to_i
    @article.month = (Time.now.in_time_zone('Tokyo') - 3600 * 5).strftime('%m').to_i
    @article.day   = (Time.now.in_time_zone('Tokyo') - 3600 * 5).strftime('%d').to_i
    @article.date  = Date.new(@article.year, @article.month, @article.day)

    if @article.save
      redirect_to '/' + format('%02d', @article.year) + '/' + format('%02d', @article.month) + '/' + format('%02d', @article.day), notice: 'Published successfully!'
    else
      flash.now[:alert] = 'Publish failed...'
      render 'new'
    end
  end

  def edit
    environment = ENV['RAILS_ENVIRONMENT'] || ENV['RAILS_ENV'] || 'development'
    if environment == 'production'
      @article = Article.find_by!(year: params[:year], month: params[:month], day: params[:day])
      @post_url = '/' + params[:year] + '/' + params[:month] + '/' + params[:day]
    # 開発環境ではポストしていない日に新たに記事を追加して編集することができるようにする
    elsif environment == 'development'
      begin
        @article = Article.find_by!(year: params[:year], month: params[:month], day: params[:day])
      rescue StandardError
        @article = Article.new
        @article.year  = params[:year].to_i
        @article.month = params[:month].to_i
        @article.day   = params[:day].to_i
        @article.date  = Date.new(@article.year, @article.month, @article.day)
      end

      @post_url = '/' + params[:year] + '/' + params[:month] + '/' + params[:day]
    end
  end

  def update
    environment = ENV['RAILS_ENVIRONMENT'] || ENV['RAILS_ENV'] || 'development'
    if environment == 'production'
      @article = Article.find_by!(year: params[:year], month: params[:month], day: params[:day])

      if @article.update(update_article_and_templated_articles_params)
        redirect_to '/' + format('%02d', @article.year) + '/' + format('%02d', @article.month) + '/' + format('%02d', @article.day), notice: 'Updated successfully!'
      else
        flash.now[:alert] = 'Updated failed...'
        render 'edit'
      end
    # 開発環境ではポストしていない日に新たに記事を追加して編集することができるようにする
    elsif environment == 'development'
      begin
        @article = Article.find_by!(year: params[:year], month: params[:month], day: params[:day])

        if @article.update(update_article_and_templated_articles_params)
          redirect_to '/' + format('%02d', @article.year) + '/' + format('%02d', @article.month) + '/' + format('%02d', @article.day), notice: 'Updated successfully!'
        else
          flash.now[:alert] = 'Updated failed...'
          render 'edit'
        end
      rescue StandardError
        @article = Article.new(article_params)

        @article.year  = params[:year].to_i
        @article.month = params[:month].to_i
        @article.day   = params[:day].to_i
        @article.date  = Date.new(@article.year, @article.month, @article.day)

        if @article.save
          redirect_to '/' + format('%02d', @article.year) + '/' + format('%02d', @article.month) + '/' + format('%02d', @article.day), notice: 'Appended successfully!'
        else
          flash.now[:alert] = 'Append failed...'
          render 'edit'
        end
      end
    end
  end

  def destroy
    @article = Article.find_by!(year: params[:year], month: params[:month], day: params[:day])
    @article.destroy

    redirect_to '/' + format('%02d', @article.year) + '/' + format('%02d', @article.month), notice: 'Deleted successfully!'
  end

  def search
    @error_message  = ''
    @failed_keyword = ''

    if params[:q].blank?
      @error_message = 'The query string must not be empty.'
      return
    end

    # maximum_characters は本当は定数にしたいけど
    # Ruby ではなぜかメソッド内で定数を定義できないので
    # とりあえず変数で定義しておく
    maximum_characters = 128
    if params[:q].length > maximum_characters
      @error_message = "The query string is too long. The maximum number of characters are #{maximum_characters}."
      return
    end

    @page = params[:page] || 1
    unless @page.to_s =~ /^[0-9]+$/ && @page.to_s != '0'
      @error_message = 'A positive integer without the plus sign is expected in the page parameter.'
      return
    end
    @page = @page.to_i

    quantities = 10
    @results = Article.where('text LIKE(?)', '%' + params[:q] + '%').offset((@page - 1) * quantities).limit(quantities)

    hitcount = Article.where('text LIKE(?)', '%' + params[:q] + '%').count
    @number_of_pages = hitcount.to_i / quantities.to_i
    @number_of_pages += 1 if hitcount.to_i % quantities.to_i != 0

    if @results.empty?
      if hitcount != 0 && @page > @number_of_pages
        @error_message = 'There are no search results anymore.'
      else
        @error_message  = 'No matches for'
        @failed_keyword = params[:q].to_s
      end
    end
  end

  private

  def article_params
    params.require(:article).permit(:text)
  end

  def article_and_templated_articles_params
    params.require(:article).permit(:text, templated_articles_attributes: [:title, :body, :position])
  end

  def update_article_and_templated_articles_params
    params.require(:article).permit(:text, templated_articles_attributes: [:title, :body, :position, :_destroy, :id])
  end

  def signed_in?
    redirect_to login_path if current_user.nil?
  end
end
