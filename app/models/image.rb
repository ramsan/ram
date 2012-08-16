=begin
  create_table "images", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "memory_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "google_thumb"
    t.string   "google_main"
    t.text     "caption"
    t.integer  "user_id"
    t.string   "google_page_url"
	  t.string   "external_url"
  end  
=end
require 'open-uri'

class Image < ActiveRecord::Base
  belongs_to :memory, :counter_cache => true, :touch => true
  belongs_to :user
  #after_create :share_to_facebook #if proc { |image| !image['caption'].blank? }
  after_create :push_remote_image_to_server, :if => :is_from_google?
  has_attached_file :image, :styles => {:large => '640x480>', :medium => '320x240>', :mosaic => '140x105>', :small => '160x120>', :thumb => "55x55>" },
    :convert_options => {:mosaic => "-quality 75" },
    :default => :small,
    :storage => :s3,
    :s3_credentials => CONFIG[:amazon],
    :path => ":attachment/:id/:style/:basename.:extension",
    :bucket => CONFIG[:amazon][:s3_bucket]
  
  #validates_presence_of :memory
  #validates_associated :memory
  validates_presence_of :user
  validates_associated :user
  
  scope :by_user, lambda {|user| where(:user_id => user.id)}
  scope :not_by_user, lambda {|user| where('user_id != ?', user.id)}
  scope :as_image, where(:caption => nil)
  scope :as_comment, where(Image.arel_table[:caption].not_eq(nil))
  
  
  #Virtual attribute to fetch images from the source
  attr_accessor :image_from_url
  
  def self.default_memory
    'iso_btn.png'
  end
  
  def self.default_user
    'default-user-icon.gif'
  end
  
  def this_url(style = nil)
    if image.present?
      if style.nil?
        image.url
      else
        image.url(style)
      end
    elsif !external_url.blank?
      external_url
    else
      if style.nil? || %w(thumb small).include?(style.to_s)
        google_thumb
      else
        google_main
      end
    end
  end
  
  def has_image?
    !google_thumb.blank? || image.present? || !external_url.blank?
  end
  
  def is_image?
    caption.nil?
  end
  
  def is_comment?
    !caption.nil?
  end
  
  def is_from_google?
    !google_thumb.blank?
  end
  
  # private
  ##SPEEDING UP THE SERVED IMAGES FILES FROM ASSETS SERVER
  #Saving memories images to asset server
  def push_remote_image_to_server
    if google_main.present?
      remote_image_url = google_main
      self.image_from_url = download_remote_image(remote_image_url)
      self.image = image_from_url
      self.save
    end
  end
  
  #Fetching the image from the source
  def download_remote_image(remote_image_url)
      io = open(URI.parse(remote_image_url))
      def io.original_filename; base_uri.path.split('/').last; end
      io.original_filename.blank? ? nil : io
      rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end
  
  def get_fb_user
    begin
      FbGraph::User.me(self.user.fb_auth_token).fetch
    rescue => e
      Rails.logger.error "[ERROR] #{File.basename(__FILE__)}[#{__LINE__}]: #{e.inspect}"
      nil
    end
  end
  
  def fb_share_hash
    hsh = {
      :access_token => user.fb_auth_token,
      :message => I18n.t('facebook.commented', :name => self.memory.name),
      :link => CONFIG[:app_url] + Rails.application.routes.url_helpers.memory_path(self.memory),
      :name => I18n.t('facebook.name', :name => self.memory.name)
    }
    hsh[:description] = self.caption if !self.caption.blank?
    hsh[:picture] = self.memory.main_image.this_url if !self.memory.main_image.nil?
    hsh
  end

  def share_to_facebook
    if self.user.comment_preferences. == true && !self.caption.empty?
      fb_user = user.get_fb_user
      if fb_user
        fb_hsh = fb_share_hash
        Rails.logger.debug "[FACEBOOK COMMENT SHARED] #{File.basename(__FILE__)}[#{__LINE__}]: #{fb_hsh.to_yaml}"
        fb_user.feed!(
          fb_hsh
        )
      end
    end
  end
end
