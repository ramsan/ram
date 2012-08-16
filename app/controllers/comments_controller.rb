class CommentsController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    if @comment.save
      flash[:notice] = I18n.t('success', :obj => 'Comment', :action => 'added to the Memory')
      redirect_to memory_path(@comment.memory)
    else
      redirect_to memory_path(@comment.memory, :content => (params[:comment][:conent].blank? ? '' : URI.escape(params[:comment][:conent])))
      flash[:alert] = I18n.t('fail', :obj => 'the Memory', :action => 'adding your Comment to')
    end
  end
end
