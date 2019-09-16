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

    article = find_todays_article
    if article
      @todays_diary_title = 'Edit today’s diary'
      @todays_diary_url = build_edit_path(article.year, article.month, article.day)
    else
      @todays_diary_title = 'Create a new diary'
      @todays_diary_url = new_path
    end
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
    @templates = Template.all.order('position ASC')

    article = find_todays_article
    if article
      redirect_to build_edit_path(article.year, article.month, article.day)
      return
    end

    @article = Article.new
    @article.templated_articles.build
    @post_url = '/new'
    @form_title = 'Create a new diary'
    @back_link_url = root_path
  end

  def create
    @article = Article.new(article_params)

    @article.year  = (Time.now.in_time_zone('Tokyo') - 3600 * 5).strftime('%Y').to_i
    @article.month = (Time.now.in_time_zone('Tokyo') - 3600 * 5).strftime('%m').to_i
    @article.day   = (Time.now.in_time_zone('Tokyo') - 3600 * 5).strftime('%d').to_i
    @article.date  = Date.new(@article.year, @article.month, @article.day)

    if @article.save
      redirect_to '/' + format('%02d', @article.year) + '/' + format('%02d', @article.month) + '/' + format('%02d', @article.day)
    else
      @templates = Template.all.order('position ASC')
      @article.templated_articles.build
      @post_url = '/new'
      @form_title = 'Create a new diary'
      @back_link_url = root_path

      flash.now[:alert] = 'Publish failed...'
      render 'new'
    end
  end

  def edit
    @article = Article.find_by!(year: params[:year], month: params[:month], day: params[:day])
    @post_url = '/' + params[:year] + '/' + params[:month] + '/' + params[:day]
    @form_title = 'Edit the diary'
    @back_link_url = show_path
  end

  def update
    @article = Article.find_by!(year: params[:year], month: params[:month], day: params[:day])

    if @article.update(update_article_params)
      redirect_to '/' + format('%02d', @article.year) + '/' + format('%02d', @article.month) + '/' + format('%02d', @article.day)
    else
      @post_url = '/' + params[:year] + '/' + params[:month] + '/' + params[:day]
      @form_title = 'Edit the diary'
      @back_link_url = show_path

      flash.now[:alert] = 'Updated failed...'
      render 'edit'
    end
  end

  def destroy
    @article = Article.find_by!(year: params[:year], month: params[:month], day: params[:day])

    # production 環境では日記を削除するケースはほぼないので安全のために削除しない
    @article.destroy if Rails.env.development?

    redirect_to '/' + format('%02d', @article.year) + '/' + format('%02d', @article.month)
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

  def find_todays_article
    year  = (Time.now.in_time_zone('Tokyo') - 3600 * 5).strftime('%Y').to_i
    month = (Time.now.in_time_zone('Tokyo') - 3600 * 5).strftime('%m').to_i
    day   = (Time.now.in_time_zone('Tokyo') - 3600 * 5).strftime('%d').to_i
    Article.find_by(year: year, month: month, day: day)
  end

  def build_edit_path(year, month, day)
    "/edit/#{format('%02d', year)}/#{format('%02d', month)}/#{format('%02d', day)}"
  end

  def article_params
    params.require(:article).permit(:text, templated_articles_attributes: [:title, :body, :position])
  end

  def update_article_params
    params.require(:article).permit(:text, templated_articles_attributes: [:title, :body, :position, :_destroy, :id])
  end

  def signed_in?
    redirect_to login_path if current_user.nil?
  end
end
