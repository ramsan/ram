class Email < ActionMailer::Base
  default :from => "#{CONFIG[:app_name]} <#{CONFIG[:email][:system]}>"
  include ApplicationHelper
  
  def send_to_a_friend(memory, params)
    @memory = Memory.find(memory.id)
    @image = @memory.images.first.this_url(:small)
    @image_title = @memory.name
    @params = params
    
    mail(:to => params[:friend_email], :subject => 'Do you remember "'+@memory.name+'"?') do |format|
      format.html
    end
  end

  def user_conform(user)
    u = User.find_by_id(user)
    @user = u.first_name
    @link_text="Click to Conform "
    u_url ="http://localhost:3000/conform?id="+u.id.to_s+"key=1"
    @link_url=u_url

      mail(:to => u.email, :subject => "Conformantion for Doyourememberme App ",:template_name => 'conformmail', :content_type => "text/html" )

  end

  
  def notify_comment_on_owned_memory(comment)
    @memory = Memory.find(comment.memory_id)
    @image = @memory.images.first.this_url(:small)
    @image_title = @memory.name
    @user = @memory.user.name
    @user_id = @memory.user_id
    @other_user = comment.user.name
    @event = 'commented on your memory'
    @link_text = 'View the comment'
    @link_url = memory_url(comment.memory)
    mail(:to => comment.memory.user.email_field, :subject => CONFIG[:app_name] + ' - Comment on your memory', :template_name => 'notification', :content_type => "text/html")
  end
  
  def notify_comment_made_by_followee(comment, follower)
    @memory = Memory.find(comment.memory_id)
    @image = @memory.images.first.this_url(:small)
    @image_title = @memory.name
    @user = follower.name
    @user_id = @memory.user_id
    @other_user = comment.user.name
    @event = 'commented on a memory'
    @link_text = 'View the memory'
    @link_url = memory_url(comment.memory)
    # mail(:bcc => comment.user.followers.select{|user| user.notify?(User::NOTIFY_COMMENT_MADE_BY_FOLLOWEE)}.collect(&:email_field), :subject => CONFIG[:app_name] + ' - Comment on your memory', :template_name => 'notification')
    mail(:to => follower.email_field, :subject => CONFIG[:app_name] + ' - Comment on a memory', :template_name => 'notification')
  end
  
  def notify_memory_added_by_followee(memory, follower)
    @memory = Memory.find(memory)
    @image = @memory.images.first.this_url(:small)
    @image_title = @memory.name
    # @user = 'follower of ' + memory.user.name
    @user = follower.name
    @user_id = @memory.user_id
    @other_user = memory.user.name
    @event = 'created a new memory'
    @link_text = 'View the memory'
    @link_url = memory_url(memory)
    mail(:to => follower.email_field, :subject => CONFIG[:app_name] + ' - new memory from ' + memory.user.name, :template_name => 'notification')
  end
  
  ###FROM HERE
  def notify_user_following_you(following)
    if !following.follower.fb_picture.blank?
      @image = get_fb_image(following.follower.my_profile_image)
    elsif following.follower.profile_image?
      @image = following.follower.profile_image(:small)
    else
      @image = following.follower.my_profile_image
    end
    @image_title = following.follower.name
    @user = following.followee.name
    @user_id = following.followee_id
    @other_user = following.follower.name
    @event = 'started following you'
    @link_text = "View #{@other_user}'s profile"
    @link_url = users_profile_url(following.follower)
    mail(:to => following.followee.email_field, :subject => CONFIG[:app_name] + ' - New follower!', :template_name => 'notification')
  end
  
  def notify_team(visit)
    @image = "#{CONFIG[:app_url]}/assets/happy-face.png"
    @image_title = "Good News!"
    @visit = Visit.find(visit)
    mail(:to => "info@doyouremember.com", :subject => "Beta Test Sign Up")
  end
end
