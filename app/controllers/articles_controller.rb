class ArticlesController < ApplicationController

  before_action :move_to_index, except: [:index, :show]

  def index
    @articles = Article.includes(:user).page(params[:page]).per(5).order("created_at DESC")
  end

  def new
    @article = Article.new
  end

  def create
    Article.create(image: article_params[:image], text: article_params[:text], user_id: current_user.id)
  end

  def destroy
      article = Article.find(params[:id])
      article.destroy if article.user_id == current_user.id
  end

  def edit
      @article = Article.find(params[:id])
  end

  def update
      article = Article.find(params[:id])
      if article.user_id == current_user.id
        article.update(article_params)
      end
  end

  def show
    @article = Article.find(params[:id])
    @comment = Comment.new
    @comments = @article.comments.includes(:user)
  end


  private
  def article_params
    params.permit(:image, :text).merge(user_id: current_user.id)
  end

  def move_to_index
      redirect_to action: :index unless user_signed_in?
  end

end
