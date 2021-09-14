class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update,:edit, :destroy]
  before_action :require_user_logged_in
  before_action :correct_user, only: [:index,:show,:edit, :destroy]
  before_action :todays_posts_exists, only:  [:new]
  before_action :correct_today, only: [:edit]
  
  def index
    @posts = Post.all
    @user = User.find_by(id: @posts)
  end 
  
  def show
  end
  
  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = '行動目標計画ページを投稿しました。'
       redirect_to @post
    else
      flash.now[:danger] = '行動目標計画ページの投稿に失敗しました。'
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if  @post.update(post_params)
      flash[:success] = '行動目標計画ページは正常に更新されました'
      redirect_to @post
    else
      flash.now[:danger] = '行動目標計画ページは更新されませんでした'
      render  :edit
    end
  end
  
  def destroy
    @post.destroy
    flash[:success] = '行動目標計画ページは正常に削除されました'
    redirect_to  user_path(current_user)
  end


  private
  
  def set_post
     @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:day,:goal1,:goal2,:goal3,:content,:feeling1,:feeling2)
  end
  
  def correct_user
     @post = current_user.posts.find_by(id: params[:id])
    unless  @post
      redirect_to root_url
    end
  end
  
  def correct_today
    @post = Post.find(params[:id])
    if @post.day < Date.today
      flash[:danger] = '過去の日付の行動目標は編集できません'
       redirect_to root_url
    end 
  end
  
  
  def todays_posts_exists
    post = current_user.posts.find_by(day: Time.zone.now)
    if post
      redirect_to post_path(post)
      flash[:success] = '行動目標計画ページはすでに登録されています'
    end
  end
end
