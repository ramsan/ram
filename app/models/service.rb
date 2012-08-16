class Service < ActiveRecord::Base
  
  ENABLED = %w(facebook google twitter)
  
  #Associations
  belongs_to :user
  
  #Securing
  attr_accessible :provider, :uid, :uname, :uemail
  
  #Twitter registration workaround
  after_create :update_twitter_auth_account
  
  #CREATE A BIDIRECTIONAL RELATIONSHIP IF THE USER IS USING FACEBOOK AND WAS INVITED
  after_create :update_facebook_friendship
  
  
  #Twitter workaround
  def update_twitter_auth_account
    if self.provider == "twitter"
      self.uemail = self.user.email
      self.save
    end
  end
  
  #Is facebook the provider?
  def is_facebook?
    self.provider == "facebook"
  end
  
  #This user was invited by a friend?
  def was_invited?
    Invitation.find_by_fb_friend(self.uid) != nil
  end
  
  #Do a bidirectional friend relationship
  def update_facebook_friendship
    if self.is_facebook? && self.was_invited?
      invitation = Invitation.find_by_fb_friend(self.uid)
      host_user = User.find(invitation.host_user_id)
      guess_user = User.find(self.user_id)
      host_follows = Following.where(:followee_id => host_user.id, :follower_id => guess_user.id)
      guess_follows = Following.where(:followee_id => guess_user.id, :follower_id => host_user.id)
      if host_follows.empty?
        Following.create(:followee_id => host_user.id, :follower_id => guess_user.id)
      end
      if guess_follows.empty?
        Following.create(:followee_id => guess_user.id, :follower_id => host_user.id)
      end
      invitation.update_attribute(:fb_processed_relationship, true)
      pending_invitations = Invitation.where(:fb_user => invitation.fb_user, :fb_friend => invitation.fb_friend, :fb_processed_relationship => false)
      pending_invitations.each do |p|
        p.update_attribute(:fb_processed_relationship, true)
      end
    end
  end
end
