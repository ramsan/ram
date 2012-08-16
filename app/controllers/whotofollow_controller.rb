class WhotofollowController < ApplicationController
  def index

    if request.method.eql?('POST')
      session[:search] = nil
      session[:search] = params[:search]
      @users = User.where("first_name LIKE ? OR last_name LIKE ?","%#{session[:search]}%", "%#{session[:search]}%")
    else
      @users = User.where('id != ?', current_user.id)
    end

  end

  private
  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "first_name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def follow
    assign_follows(params[:followee_id])
    render :layout => false
  end
end
