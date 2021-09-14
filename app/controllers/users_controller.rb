class UsersController < ApplicationController
    before_action :require_user_logged_in, except: [:new,:create]
    before_action :set_user, only: [:show, :update,:edit,:followings,:followers,:posts,:reports,:favorites,:timelines, :destroy]
     before_action :correct_user, only: [:edit,:destroy]
def index
    @pagy, @users = pagy(User.order(id: :desc), items: 6)
end

def show 

end 

def new
    @user = User.new
end 

def create
    @user = User.new(user_params)
    
    if @user.save
        flash[:success] = 'ユーザを登録しました。'
        redirect_to @user
    else
        flash.now[:danger] = 'ユーザーの登録に失敗しました。'
        render :new
    end 
end 

def edit
end 

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ありがとうございました。またのご利用を心よりお待ちしております。"
    redirect_to root_url
  end

def update
    if current_user == @user
        if @user.update(user_params)
            flash[:success] = 'ユーザ情報を編集しました。'
            redirect_to @user
        else
            flash.now[:danger] = 'ユーザ情報の編集に失敗しました。'
            render :edit
        end 
    else
        redirect_to root_url
    end
end 


def followings
    @pagy,@followings = pagy(@user.followings.order(id: :desc), items: 6)
    counts(@user)
end 
    
def followers
    @pagy,@followers = pagy(@user.followers.order(id: :desc), items: 6)
    counts(@user)
end 

def posts
    @pagy, @posts = pagy(@user.posts.order(created_at: :desc), items: 6)
end 

def reports
    @pagy, @reports = pagy(@user.reports.order(created_at: :desc), items: 6)
end 

def timelines
    @pagy, @reports = pagy(current_user.feed_reports.order(created_at: :desc), items: 6)
end  

def favorites
    @posts = current_user.posts.find_by(day: Time.zone.now)
    @pagy, @favorites = pagy(@user.favorites.order(created_at: :desc), items: 6)
    counts(@user)
end 




private

def set_user
   @user = User.find(params[:id])
end 

def user_params
    params.require(:user).permit(:name, :email, :goal_day, :goal, :introduction, :password, :password_confirmation)
end 

  def correct_user
     @user = User.find(params[:id])
     unless current_user == @user
    flash[:danger] = '他のユーザーの編集はできません。'
      redirect_to root_url
    end
  end


end
