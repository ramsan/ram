=begin
  create_table "users", :force => true do |t|
    t.string   "email",                                     :default => "",   :null => false
    t.string   "encrypted_password",         :limit => 128, :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                             :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "haslocalpw",                                :default => true, :null => false
    t.string   "profile_image_file_name"
    t.string   "profile_image_content_type"
    t.integer  "profile_image_file_size"
    t.datetime "profile_image_updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "birth_year"
    t.string   "zip_code"
    t.string   "gender"
    t.text     "about_me"
    t.string   "fb_auth_token"
    t.string   "fb_picture"
    t.string   "fb_identifier"    
    t.integer  "notification_preferences",                  :default => 15
    t.integer  "system_preferences",                        :default => 0
  end  
=end

class User < ActiveRecord::Base
  include ActionView::Helpers::AssetTagHelper
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable, :timeoutable and :omniauthable, :confirmable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable
  attr_accessor :profile_image_url#, :full_name
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :haslocalpw, :profile_image, :avatar,
    :profile_image_url, :birth_year, :zip_code, :gender, :about_me, :fb_auth_token, :fb_picture, :fb_identifier, :services_attributes, :full_name, 
    :system_preferences, :comment_preferences

  attr_readonly :admin

  has_attached_file :profile_image, :styles => {:small => "120x120>", :profile => "55x55>" }, :default => :profile, :default_url => CONFIG[:app_url] + "\/assets\/" + 'default-user-icon.gif',
    :storage => :s3,
    :s3_credentials => CONFIG[:amazon],
    :path => ":attachment/:id/:style/:basename.:extension",
    :bucket => CONFIG[:amazon][:s3_bucket]

  #Associations
  has_many :services, :dependent => :destroy
  has_many :memories
  has_and_belongs_to_many :also_remembers, :class_name => 'Memory'
  has_many :images
  has_many :my_followers, :class_name => 'Following', :foreign_key => 'followee_id'
  has_many :followers, :through => :my_followers  
  has_many :my_followees, :class_name => 'Following', :foreign_key => 'follower_id'
  has_many :followees, :through => :my_followees
  has_many :showdowns
  has_many :votes, :dependent => :destroy
  
  GENDER = %w(male female)
  
  #Twitter signup workaroud
  accepts_nested_attributes_for :services, :allow_destroy => true, :reject_if => :all_blank
  
  NOTIFY_MEMORY_COMMENT = 1
  NOTIFY_FOLLOWED_BY_USER = 2
  NOTIFY_MEMORY_ADDED_BY_FOLLOWEE = 4
  NOTIFY_COMMENT_MADE_BY_FOLLOWEE = 8
  
  SYSTEM_AUTO_FB_MEMORY_POST = 1 
  SYSTEM_AUTO_FB_COMMENT_POST = 1

  validates_presence_of :first_name, :last_name, :birth_year
  validates_inclusion_of :gender, :in => GENDER, :allow_nil => true, :allow_blank => true
  validates_numericality_of :birth_year, :allow_nil => true, :allow_blank => true
  
  scope :most_prolific, lambda{|*limit|
    search_limit = limit.first.nil? ? 20 : limit.first 
    find_by_sql(['select u.* from users u, memories m where u.id=m.user_id group by m.user_id order by count(m.user_id) desc limit ?', search_limit])
  }
  
  scope :with_memories, joins(:memories).having('count(memories.id) > 0').group('memories.user_id')
  
  before_create :full_name
  
  before_create :download_profile_pic, :if => :is_a_twitter_user?
  
  
  
  before_save do
    self.email.downcase! if self.email
    self.password.downcase! if self.password
    self.password_confirmation.downcase! if self.password_confirmation
  end
  
  #It fetch the virtual field FULL_NAME if exists
  def full_name
      [first_name, last_name].join(' ') if first_name && last_name
  end
  
  # Split the full_name to be saved
  def full_name=(name)
    split = name.split(' ', 2)
    self.first_name = split.first
    self.last_name = split.last
  end

  def self.find_for_authentication(conditions)
    conditions[:email].downcase!
    super(conditions)
  end
  
  def self.fb_identifiers
    User.select(:fb_identifier).where(User.arel_table[:fb_identifier].not_eq(nil))
  end
  
  
  def public_memories
    memories.where(:is_anonymous => false)
  end
  
  def comments
    Image.where(:user_id => self.id).where(['memories.user_id != ?', self.id]).joins(:memory).order("created_at DESC")
  end
  
  def all_comments
    Image.where(:user_id => self.id).joins(:memory).order("created_at DESC")
  end

  def name
    arr = []
    arr.push(first_name) unless first_name.blank?
    arr.push(last_name) unless last_name.blank?
    arr.join(' ')
  end
  
  def total_memories
    memories.count + also_remembers.count
  end
  
  def memories_in_common(other_user)
    (memories + also_remembers) & (other_user.memories + other_user.also_remembers) 
  end
  
  def get_fb_user
    begin
      FbGraph::User.me(fb_auth_token).fetch
    rescue => e
      Rails.logger.error "[ERROR] #{File.basename(__FILE__)}[#{__LINE__}]: #{e.inspect}"
      nil
    end
  end
  
  def update_profile_from_facebook
    @fb_user = get_fb_user
    #Rails.logger.debug "@fb_user: #{@fb_user.to_yaml}"
    if @fb_user
      self.email = @fb_user.email if !@fb_user.email.blank?
      self.first_name = @fb_user.first_name if !@fb_user.first_name.blank?
      self.last_name = @fb_user.last_name if !@fb_user.last_name.blank?
      self.birth_year = @fb_user.birthday.year if !@fb_user.birthday.nil?
      self.gender = @fb_user.gender if !@fb_user.gender.blank?
      self.about_me = @fb_user.bio if !@fb_user.bio.blank?
      self.fb_picture = @fb_user.picture if !@fb_user.picture.blank?
      self.fb_identifier = @fb_user.identifier 
      #zip_code
      self.save!
    else
      false
    end
  end
  
  def my_profile_image
    return fb_picture if !fb_picture.blank?
    if profile_image != nil 
      return profile_image.url(:profile) #if !profile_image.nil?
    else  
      return (CONFIG[:app_url] + "\/assets\/" + avatar) if !avatar.nil?
    end  
    # 'default-user-icon.gif'
  end
  
  def notify?(notification_bit)
    (notification_preferences & notification_bit).eql?(notification_bit)
  end
  
  def notification_enable(notification_bit)
    self.update_attribute(:notification_preferences, notification_preferences | notification_bit.to_i)
  end
  
  def notification_disable(notification_bit)
    self.update_attribute(:notification_preferences, notification_preferences ^ notification_bit.to_i)
  end
  
  def prefers?(system_bit)
    (system_preferences & system_bit).eql?(system_bit)
  end
  
  def system_enable(system_bit)
    self.update_attribute(:system_preferences, system_preferences | system_bit.to_i)
  end
  
  def system_disable(system_bit)
    self.update_attribute(:system_preferences, system_preferences ^ system_bit.to_i)
  end
  
  def comment_prefers?(comment_bit)
    (comment_preferences & comment_bit).eql?(comment_bit)
  end

  def comment_enable(comment_bit)
    self.update_attribute(:comment_preferences, comment_preferences | comment_bit.to_i)
  end
  
  def comment_disable(comment_bit)
    self.update_attribute(:comment_preferences, comment_preferences ^ comment_bit.to_i)
  end
  
  def email_field
    self.name + " <#{self.email}>"
  end
  
  def is_a_twitter_user?
    self.profile_image_url.present?
  end
  
  def download_profile_pic
    begin
      io = open(URI.parse(self.profile_image_url))
      def io.original_filename; base_uri.path.split('/').last; end
      self.profile_image = io.original_filename.blank? ? nil : io  
    rescue Timeout::Error
      self.profile_image = nil
    rescue OpenURI::Error => e
      self.profile_image = nil
    end
  end
  
end
