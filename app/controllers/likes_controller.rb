class LikesController < ApplicationController
     before_action :require_user_logged_in
     before_action :set_report
     
     
  def create    
    report = Report.find(params[:report_id])
   current_user.like(report)
    flash[:success] = 'お気に入りを追加しました'
    redirect_to @report
  end

  def destroy
    report = Report.find(params[:report_id])
    current_user.unlike(report)
    flash[:danger] = 'お気に入りを解除しました'
    redirect_to @report
  end
end

  private

  def set_report
    @report = Report.find(params[:report_id])
  end
  
