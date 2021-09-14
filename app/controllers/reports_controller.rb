class ReportsController < ApplicationController
   before_action :set_report, only: [:show, :edit, :update, :destroy]
   before_action :require_user_logged_in, except: [:index]
   before_action :correct_user, only: [:destroy,:edit]
   before_action :todays_posts_exists, only:  [:new]
   before_action :posts_not_exists, only:  [:new]
  
  def index
    @reports = Report.all
    @pagy, @reports = pagy(Report.order(created_at: :desc), items: 6)
  end 
  
  def show
    @user = @report.user
    @comments = @report.comments 
    @comment = current_user.comments.new 
  end
  
  def new
    @post = current_user.posts.find_by(day: Time.zone.now)
    @report = Report.new
  end

  def create
    @report = current_user.reports.build(report_params)
    @report.day1 = Time.zone.today
    if @report.save
      flash[:success] = '進捗報告ページを投稿しました。'
       redirect_to @report
    else
      flash.now[:danger] = '進捗報告ページの投稿に失敗しました。'
      @post = current_user.posts.find_by(day: Time.zone.now)
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if  @report.update(report_params)
      flash[:success] = '進捗報告ページは正常に更新されました'
      redirect_to @report
    else
      flash.now[:danger] = '進捗報告ページは更新されませんでした'
      render  :edit
    end
  end
  
  def destroy
    @report.destroy
    flash[:success] = '進捗報告ページは正常に削除されました'
    redirect_to  user_path(current_user)
  end


  private
  
  def set_report
     @report = Report.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:aftergoal1,:aftergoal2, :aftergoal3,:progress1,:progress2,:progress3,:achivement,:improvement)
  end
  
  def correct_user
     @report = current_user.reports.find_by(id: params[:id])
    unless  @report
      redirect_to root_url
    end
  end
  
  def todays_posts_exists
    report = current_user.reports.find_by(day1: Time.zone.now)
    if report
      redirect_to report_path(report)
      flash[:success] = '進捗報告ページはすでに登録されています'
    end
  end
  
  def posts_not_exists
    post = current_user.posts.find_by(day: Time.zone.now)
    unless post
      redirect_to new_post_path
      flash[:success] = '行動目標計画ページが登録されていません'
    end
  end
end
