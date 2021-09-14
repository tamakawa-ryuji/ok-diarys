class CommentsController < ApplicationController
before_action :set_report

    
def create
    @comment = current_user.comments.new(comment_params)
    if @comment.save
        flash[:success] = 'コメントが投稿されました'
          redirect_to @report
    else
        @user = @report.user
        @comments = @report.comments 
        @comment = current_user.comments.new 
        flash.now[:danger] = 'コメントが投稿されませんでした'
          render 'reports/show'
    end
end

  def destroy
    @comment = Comment.find(params[:id])
       if @comment.destroy
          flash[:success] = 'コメントが正常に削除されました'
           redirect_to  @report
        else
            flash.now[:danger] = 'コメントが削除されませんでした'
             render 'reports/show'
        end
  end


private
  def set_report
  @report = Report.find(params[:report_id])
  end

  def comment_params
    params.require(:comment).permit(:comment_content).merge(user_id: current_user.id, report_id: params[:report_id]) 
  end
end