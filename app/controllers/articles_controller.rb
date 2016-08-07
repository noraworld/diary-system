class ArticlesController < ApplicationController
  before_action :signed_in?, only: [:new, :create, :edit, :update, :destroy]

  def index
    # rootにアクセスしたときは@yearは今年
    @year = params[:year].to_i
    if @year === 0
      @year = Time.now.in_time_zone('Tokyo').strftime('%Y').to_i
    end

    # rootにアクセスしたときは@monthは今月
    @month = params[:month].to_i
    if @month === 0
      @month = Time.now.in_time_zone('Tokyo').strftime('%m').to_i
    end

    @articles = Article.order('day').where(year: @year).where(month: @month)
  end

  def show
    year  = params[:year].to_i
    month = params[:month].to_i
    day   = params[:day].to_i
    @article = Article.find_by!(year: year, month: month, day: day)
  end

  def new
    @article = Article.new
    @post_url = '/new'
  end

  def create
    @article = Article.new(article_params)

    @article.year  = (Time.now.in_time_zone('Tokyo') - 3600 * 5).strftime('%Y').to_i
    @article.month = (Time.now.in_time_zone('Tokyo') - 3600 * 5).strftime('%m').to_i
    @article.day   = (Time.now.in_time_zone('Tokyo') - 3600 * 5).strftime('%d').to_i

    if @article.save
      redirect_to '/' + format('%02d', @article.year) + '/' + format('%02d', @article.month) + '/' + format('%02d', @article.day), notice: 'Published successfully!'
    else
      flash.now[:alert] = 'Publish failed...'
      render 'new'
    end
  end

  def edit
    @article = Article.find_by!(year: params[:year], month: params[:month], day: params[:day])
    @post_url = '/' + params[:year] + '/' + params[:month] + '/' + params[:day]
  end

  def update
    @article = Article.find_by!(year: params[:year], month: params[:month], day: params[:day])

    if @article.update(article_params)
      redirect_to '/' + format('%02d', @article.year) + '/' + format('%02d', @article.month) + '/' + format('%02d', @article.day), notice: 'Updated successfully!'
    else
      flash.now[:alert] = 'Updated failed...'
      render 'edit'
    end
  end

  def destroy
    @article = Article.find_by!(year: params[:year], month: params[:month], day: params[:day])
    @article.destroy

    redirect_to '/' + format('%02d', @article.year) + '/' + format('%02d', @article.month), notice: 'Deleted successfully!'
  end

  private
    def article_params
      params.require(:article).permit(:text)
    end

    def signed_in?
      if current_user == nil
        redirect_to login_path
      end
    end
end
