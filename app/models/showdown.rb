class Showdown < ActiveRecord::Base
  require 'open-uri'
  
  #Decades Options
  DECADES = {
    1 => "< 1940", 
    2 => "1940's", 
    3 => "1950's", 
    4 => "1960's", 
    5 => "1970's", 
    6 => "1980's", 
    7 => "1990's", 
    8 => "2000's", 
    9 => "2010's"
  }
  
  #Scopes
  default_scope order('rand()') 
  
  #Security Access
  attr_accessible :question, :memory_1, :image_m1, :memory_2, :image_m2, :memory_3, :image_m3, :memory_4, :image_m4, :memory_5, :image_m5, :user_id, :category_id, :decade,
  :image_1_google_main, :image_1_google_thumb, :image_1_google_page_url,
  :image_2_google_main, :image_2_google_thumb, :image_2_google_page_url,
  :image_3_google_main, :image_3_google_thumb, :image_3_google_page_url,
  :image_4_google_main, :image_4_google_thumb, :image_4_google_page_url,
  :image_5_google_main, :image_5_google_thumb, :image_5_google_page_url
  
  #Associations
  belongs_to :user
  belongs_to :category
  has_many :votes, :dependent => :destroy
  
  #Validations
  validates_presence_of :question, :memory_1, :memory_2, :message => "can't be blank"
  validates_presence_of :category_id
  validates_length_of :memory_1, :within => 3..20
  validates_length_of :memory_2, :within => 3..20
  validates_length_of :memory_3, :within => 3..20, :if => Proc.new { |m| !m.memory_3.blank? }
  validates_length_of :memory_4, :within => 3..20, :if => Proc.new { |m| !m.memory_4.blank? }
  validates_length_of :memory_5, :within => 3..20, :if => Proc.new { |m| !m.memory_5.blank? }
  
  #validates_attachment_content_type :image_m1, :content_type => ['image/jpeg', 'image/JPEG', 'image/jpg', 'image/JPG', 'image/png', 'image/PNG', 'image/gif', 'image/GIF'], :message => 'file type is not allowed (only jpeg/png/gif images)'
  #validates_attachment_content_type :image_m2, :content_type => ['image/jpeg', 'image/JPEG', 'image/jpg', 'image/JPG', 'image/png', 'image/PNG', 'image/gif', 'image/GIF'], :message => 'file type is not allowed (only jpeg/png/gif images)'
  #validates_attachment_content_type :image_m3, :content_type => ['image/jpeg', 'image/JPEG', 'image/jpg', 'image/JPG', 'image/png', 'image/PNG', 'image/gif', 'image/GIF'], :message => 'file type is not allowed (only jpeg/png/gif images)'
  #validates_attachment_content_type :image_m4, :content_type => ['image/jpeg', 'image/JPEG', 'image/jpg', 'image/JPG', 'image/png', 'image/PNG', 'image/gif', 'image/GIF'], :message => 'file type is not allowed (only jpeg/png/gif images)'
  #validates_attachment_content_type :image_m5, :content_type => ['image/jpeg', 'image/JPEG', 'image/jpg', 'image/JPG', 'image/png', 'image/PNG', 'image/gif', 'image/GIF'], :message => 'file type is not allowed (only jpeg/png/gif images)'
  
  
  
  
  #Files Uploading though Paperclip
  has_attached_file :image_m1, :styles => {:medium => '320x240>', :small => '160x160>', :thumb => "55x55>" }, :default => :small,
    :storage => :s3,
    :s3_credentials => CONFIG[:amazon],
    :path => "/showdowns/:id/m1/:style/:basename.:extension",
    :bucket => CONFIG[:amazon][:s3_bucket]

  has_attached_file :image_m2, :styles => {:medium => '320x240>', :small => '160x160>', :thumb => "55x55>" }, :default => :small,
    :storage => :s3,
    :s3_credentials => CONFIG[:amazon],
    :path => "/showdowns/:id/m2/:style/:basename.:extension",
    :bucket => CONFIG[:amazon][:s3_bucket]
    
  has_attached_file :image_m3, :styles => {:medium => '320x240>', :small => '160x160>', :thumb => "55x55>" }, :default => :small,
    :storage => :s3,
    :s3_credentials => CONFIG[:amazon],
    :path => "/showdowns/:id/m3/:style/:basename.:extension",
    :bucket => CONFIG[:amazon][:s3_bucket]
      
  has_attached_file :image_m4, :styles => {:medium => '320x240>', :small => '160x160>', :thumb => "55x55>" }, :default => :small,
    :storage => :s3,
    :s3_credentials => CONFIG[:amazon],
    :path => "/showdowns/:id/m4/:style/:basename.:extension",
    :bucket => CONFIG[:amazon][:s3_bucket]
  
  has_attached_file :image_m5, :styles => {:medium => '320x240>', :small => '160x160>', :thumb => "55x55>" }, :default => :small,
    :storage => :s3,
    :s3_credentials => CONFIG[:amazon],
    :path => "/showdowns/:id/m5/:style/:basename.:extension",
    :bucket => CONFIG[:amazon][:s3_bucket]
  
  #Virtual attribute to fetch images from the source
  attr_accessor :image_1_from_url, :image_2_from_url, :image_3_from_url, :image_4_from_url, :image_5_from_url

  # Callbacks
  #Image 1
  before_create :push_remote_image_1_to_server, :if => :image_1_is_from_google?
  before_save :push_remote_image_1_to_server, :if => :image_1_is_from_google?
  
  #Image 2
  before_create :push_remote_image_2_to_server, :if => :image_2_is_from_google?
  before_save :push_remote_image_2_to_server, :if => :image_2_is_from_google?
  
  #Image 3
  before_create :push_remote_image_3_to_server, :if => :image_3_is_from_google?
  before_save :push_remote_image_3_to_server, :if => :image_3_is_from_google?
  
  #Image 4
  before_create :push_remote_image_4_to_server, :if => :image_4_is_from_google?
  before_save :push_remote_image_4_to_server, :if => :image_4_is_from_google?

  #Image 5
  before_create :push_remote_image_5_to_server, :if => :image_5_is_from_google?
  before_save :push_remote_image_5_to_server, :if => :image_5_is_from_google?

  private
  ##SPEEDING UP THE SERVED IMAGES FILES FROM ASSETS SERVER
  
  #Image M1
  def image_1_is_from_google?
    !image_1_google_thumb.blank?
  end
  
  #Saving memory image 1 to asset server
  def push_remote_image_1_to_server
    if image_1_google_main.present?
      remote_image_1_url = image_1_google_main
      self.image_1_from_url = download_remote_image1(remote_image_1_url)
      self.image_m1 = image_1_from_url
      # self.save
    end
  end

  #Fetching the image 1 from the source
  def download_remote_image1(remote_image_1_url)
      io = open(URI.parse(remote_image_1_url))
      def io.original_filename; base_uri.path.split('/').last; end
      io.original_filename.blank? ? nil : io
      rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end

  #Image M2
  def image_2_is_from_google?
    !image_2_google_thumb.blank?
  end
  
  #Saving memory image 2 to asset server
  def push_remote_image_2_to_server
    if image_2_google_main.present?
      remote_image_2_url = image_2_google_main
      self.image_2_from_url = download_remote_image2(remote_image_2_url)
      self.image_m2 = image_2_from_url
      # self.save
    end
  end

  #Fetching the image 2 from the source
  def download_remote_image2(remote_image_2_url)
      io = open(URI.parse(remote_image_2_url))
      def io.original_filename; base_uri.path.split('/').last; end
      io.original_filename.blank? ? nil : io
      rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end

  #Image M3
  def image_3_is_from_google?
    !image_3_google_thumb.blank?
  end
  
  #Saving memory image 3 to asset server
  def push_remote_image_3_to_server
    if image_3_google_main.present?
      remote_image_3_url = image_3_google_main
      self.image_3_from_url = download_remote_image3(remote_image_3_url)
      self.image_m3 = image_3_from_url
      # self.save
    end
  end

  #Fetching the image 3 from the source
  def download_remote_image3(remote_image_3_url)
      io = open(URI.parse(remote_image_3_url))
      def io.original_filename; base_uri.path.split('/').last; end
      io.original_filename.blank? ? nil : io
      rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end

  #Image M4
  def image_4_is_from_google?
    !image_4_google_thumb.blank?
  end
  
  #Saving memory image 4 to asset server
  def push_remote_image_4_to_server
    if image_4_google_main.present?
      remote_image_4_url = image_4_google_main
      self.image_4_from_url = download_remote_image4(remote_image_4_url)
      self.image_m4 = image_4_from_url
      # self.save
    end
  end

  #Fetching the image 4 from the source
  def download_remote_image4(remote_image_4_url)
      io = open(URI.parse(remote_image_4_url))
      def io.original_filename; base_uri.path.split('/').last; end
      io.original_filename.blank? ? nil : io
      rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end


  #Image M5
  def image_5_is_from_google?
    !image_5_google_thumb.blank?
  end
  
  #Saving memory image 5 to asset server
  def push_remote_image_5_to_server
    if image_5_google_main.present?
      remote_image_5_url = image_5_google_main
      self.image_5_from_url = download_remote_image5(remote_image_5_url)
      self.image_m5 = image_5_from_url
      # self.save
    end
  end

  #Fetching the image 5 from the source
  def download_remote_image5(remote_image_5_url)
      io = open(URI.parse(remote_image_5_url))
      def io.original_filename; base_uri.path.split('/').last; end
      io.original_filename.blank? ? nil : io
      rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end
  def self.next_vote(user_voted)
    # first(:joins => :votes, :conditions => {:votes => {:user_id => user}})
    find(:all, :conditions => ["id not in (?)", user_voted])
  end

  # def self.next_vote(user)
  #     # first(:joins => :votes, :conditions => {:votes => {:user_id => user}})
  #     find(:all, :joins => :votes, :conditions => ["votes.user_id != ?", user])
  #   end


end