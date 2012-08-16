class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:profile, :become_user]
  
  def home
    @memories = current_user.memories.latest.except(:limit).page(params[:page]).per(CONFIG[:memories_per_page]) 
  end
  
  def follow
    assign_follows(params[:followee_id])    
    render :layout => false
  end
  
  def unfollow
    unassign_follows(params[:followee_id])    
    render :layout => false
  end
  
  def follow_from_profile
    assign_follows(params[:followee_id])  
    render :layout => false
  end
  
  def unfollow_from_profile
    unassign_follows(params[:followee_id])
    render :layout => false
  end
  
  def follow_from_profile_followers
    assign_follows(params[:followee_id])  
    render :layout => false
  end
  
  def unfollow_from_profile_followers
    unassign_follows(params[:followee_id])
    render :layout => false
  end  
  
  def profile
    @user = User.find(params[:id])
  end
  
  def become_user
    sign_in_and_redirect(:user, User.find(params[:id]))
  end
  
  def set_notification
    set_pref('notification')
  end
  
  def set_preference
    set_pref('system')
  end
  
  def set_comment
    set_pref('comment')
  end
  
  private
  
  def assign_follows(followee_id)
    @followee = User.find(followee_id)
    current_user.followees << @followee
    current_user.save  
  end
  
  def unassign_follows(followee_id)
    @followee = User.find(followee_id)
    current_user.followees.delete(@followee)
    current_user.save 
  end
  
  def set_pref(type)
    to_perform = params[:new_state].eql?('on') ? 'enable' : 'disable'
    eval("current_user.#{type}_#{to_perform}(#{params[:notification_bit]})")    
    render :status => 200, :nothing => true
  end

end