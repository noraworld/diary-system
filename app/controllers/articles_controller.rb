# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :signed_in?, only: %i[new create edit update destroy]

  QUANTITIES = 10

  def index
    @route = if params[:year].to_i.zero? && params[:month].to_i.zero?
               true
             else
               false
             end

    # rootにアクセスしたときは@yearは今年
    @year = params[:year].to_i
    if @year.zero?
      @year = (Time.now.in_time_zone('Tokyo') - 3600 * 5).strftime('%Y').to_i
    end

    # rootにアクセスしたときは@monthは今月
    @month = params[:month].to_i
    if @month.zero?
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
    @public_date = @article.date + @article.public_in.to_i
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

      flash.now[:alert] = 'Update failed...'
      render 'edit'
    end
  end

  def destroy
    @article = Article.find_by!(year: params[:year], month: params[:month], day: params[:day])

    # production 環境では日記を削除するケースはほぼないので安全のために削除しない
    @article.destroy if Rails.env.development?

    redirect_to '/' + format('%02d', @article.year) + '/' + format('%02d', @article.month)
  end

  def timeline
    @articles = Article.where.not(timeline: [nil, '']).order('date DESC')
  end

  def search
    @page = params[:page] || 1

    # validate search query
    @search_validator = SearchQueryForm.new(q: params[:q], page: @page)
    return if @search_validator.invalid?

    @page = @page.to_i

    # '"apple watch" iphone -android' => [["\"apple watch\""], [" iphone -android"]]
    exact_match_keywords, not_exact_match_keywords = params[:q].split(/(".+?")/).select(&:present?).partition { |keyword| keyword.include?('"') }
    # ["\"apple watch\""] => ["apple watch"]
    exact_match_keywords.each { |k| k.delete!('\"') }
    # [" iphone -android"] => ["iphone", "-android"]
    not_exact_match_keywords = not_exact_match_keywords.join.split(/[[:blank:]]+/).select(&:present?)
    # ["iphone", "-android"] => [["-android"], ["iphone"]]
    negative_keywords, positive_keywords = not_exact_match_keywords.partition { |keyword| keyword.start_with?('-') }

    @results = Article.none # => []

    # OR search
    (exact_match_keywords + positive_keywords).each do |keyword|
      @results = @results.or(Article.where('text LIKE ?', "%#{keyword}%"))
    end

    # negative keyword search
    negative_keywords.each do |keyword|
      @results.where!('text NOT LIKE ?', "%#{keyword.delete_prefix('-')}%")
    end

    # count the number of hits and pages
    hitcount = @results.count
    @number_of_pages = hitcount / QUANTITIES
    @number_of_pages += 1 unless (hitcount % QUANTITIES).zero?

    @results = @results.offset((@page - 1) * QUANTITIES).limit(QUANTITIES).order('date DESC')

    # validate search result
    @search_validator = SearchResultForm.new(results: @results, page: @page, hitcount: hitcount, number_of_pages: @number_of_pages)
    if @search_validator.invalid? # rubocop:disable Style/GuardClause
      unless @search_validator.errors.details[:results].empty?
        @failed_keyword_required = @search_validator.errors.details[:results].first[:error] == :query_not_match
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
    params.require(:article).permit(:text, :public_in, :timeline, templated_articles_attributes: %i[title body placeholder position format is_private template_id])
  end

  def update_article_params
    params.require(:article).permit(:text, :public_in, :timeline, templated_articles_attributes: %i[title body placeholder position _destroy id])
  end

  def signed_in?
    redirect_to login_path if current_user.nil?
  end
end
