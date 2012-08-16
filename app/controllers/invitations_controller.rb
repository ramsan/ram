class InvitationsController < ApplicationController
  before_filter :authenticate_user!
  
  def new
    fb_user = current_user.get_fb_user
    if fb_user
      @fb_friends = fb_user.friends.select{|fbf| !User.fb_identifiers.include?(fbf.identifier)}.sort{|a,b| a.name <=> b.name}
    else
      flash[:error] = I18n.t('controllers.invitations.new.error')
      redirect_to root_path
    end
  end
  
  def create
    user_service = current_user.services.where(:provider => "facebook").first
    fb_user = user_service.uid
    
    errors = []
    params[:fb_friends].each do |fb_identifier|
      begin        
        fb_friend = FbGraph::User.fetch(fb_identifier)
        fb_friend.feed!(
          :access_token => current_user.fb_auth_token,
          :message => I18n.t('controllers.invitations.create.message'), 
          # :link => CONFIG[:app_url],
          # :name => I18n.t('controllers.invitations.create.name', :site_name => CONFIG[:app_name]),
          :link => CONFIG[:fb_invite],
          :name => I18n.t('controllers.invitations.create.name', :site_name => CONFIG[:fb_invite]),
          :description => I18n.t('controllers.invitations.create.description'),
          :picture => CONFIG[:app_url] + '/assets/doYouRememberSquareLogo.png'
        )
        Invitation.create(:fb_user => fb_user, :fb_friend => fb_identifier, :host_user_id => current_user.id)
      rescue => e
        errors << e.message
        next
      end
      
    end
    if errors.empty?
      flash[:notice] = I18n.t('controllers.invitations.create.success')
      redirect_to root_path and return
    else
      flash[:alert] = I18n.t('controllers.errors', :errors =>  errors.join('<br/>'))
      redirect_to :action => :new  
    end
  end
end
