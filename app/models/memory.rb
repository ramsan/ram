=begin
  create_table "memories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "views",                       :default => 0
    t.integer  "decade",         :limit => 1
    t.date     "date_of_memory"
    t.boolean  "is_anonymous",                :default => false
  end  
=end

class Memory < ActiveRecord::Base
  extend ActiveSupport::Memoizable
  DECADES = {
    1 => "pre-1940", 
    2 => "1940s", 
    3 => "1950s", 
    4 => "1960s", 
    5 => "1970s", 
    6 => "1980s", 
    7 => "1990s", 
    8 => "2000s", 
    9 => "2010s"
  }
  
  belongs_to :user
  has_and_belongs_to_many :categories, :order => "name ASC"
  has_many :images, :dependent => :destroy
  accepts_nested_attributes_for :images, :allow_destroy => true
  
  #has_many :comments, :dependent => :destroy
  has_and_belongs_to_many :remembered_by, :class_name => 'User'
  
  has_many :you_tube_videos, :dependent => :destroy
  accepts_nested_attributes_for :you_tube_videos, :allow_destroy => true, :reject_if => proc { |attributes| attributes['url'].blank? }
  
  validates_presence_of :name #, :description
  validates_presence_of :user, :message => 'must be signed in to create a memory'
  #validate :name_less_than_five_words
  validates_length_of :name, :maximum => 60
  
  validates_inclusion_of :decade, :in => DECADES.keys, :allow_blank => true, :allow_nil => true
  validates_numericality_of :sale_price, :message => "must be a number", :allow_nil => true
  validate :has_one_category
  
  scope :latest, order('created_at desc')
  scope :most_popular, order('related_memories_count Desc, views Desc, created_at Desc')
  scope :has_images, where('images_count >= ?', 1)
  scope :suspended, where(:suspended => false)
  scope :list_view, lambda { |order, updown| order("#{order + " " + updown}") }
  
  attr_accessor :share_on_facebook
  after_create :share_to_facebook, :count_related_memories
  
  attr_accessible :name, :description, :decade, :date_of_memory, :is_anonymous, :year, :tags, :sale_link, :sale_price, 
  :images_attributes, :you_tube_videos_attributes, :share_on_facebook, :category_ids, :timelined, :timeline_date
  
  
  def self.random
    Memory.all[rand(Memory.count)]
  end
  
  def self.similar_demographics(birth_year, gender = nil, user_id = nil)
    user_str = 'User.where(:birth_year => (birth_year.to_i - 5)..(birth_year.to_i + 5))'
    # user_str += '.where(:gender => gender)' if gender
    arel_str = "Memory.where(:user_id => #{user_str})"
    arel_str += ".where('user_id != ?',user_id)" if user_id
    eval(arel_str)    
  end
  
  def self.suggested_memories_for_guess(birth_year)
    user_str = 'User.where(:birth_year => (birth_year.to_i - 8)..(birth_year.to_i + 8))'
    arel_str = "Memory.where(:user_id => #{user_str})"
    eval(arel_str)
  end


  def self.in_decade(decade)
      where(:decade => decade)
  end

  def self.in_category(category)
      joins(:categories).where("categories_memories.category_id = ?", category)
  end

  # no longer used, but let's keep it around to be safe:
  
  #Find by categories
  # def self.with_category(category, limit)
  #   unless limit
  #     limit = 18
  #   end
  #   all(:joins => :categories, :conditions => ["category_id = ?",category], :limit => limit, :order => "created_at DESC")
  # end
  
  def owner
    user
  end
  
  def to_param
    self.id.to_s + '-' + self.name.parameterize
  end
  
  def user_images
    images.as_image.by_user(user)
  end
  
  def main_image
    user_images.first
  end
  
  def additional_images
    user_images.slice(1, user_images.count - 1)
  end
  
  def user_videos
    you_tube_videos.where(:user_id => self.user.id)
  end
  
  def nonuser_videos
    you_tube_videos.where('user_id != ?', self.user.id)
  end
  
  def comments
    images.as_comment
  end
  
  def decade_name
    DECADES[self.decade]
  end
  
  def fb_share_hash
    hsh = {
      :access_token => user.fb_auth_token,
      :message => I18n.t('facebook.message', :name => self.name), 
      :link => CONFIG[:app_url] + Rails.application.routes.url_helpers.memory_path(self),
      :name => I18n.t('facebook.name', :name => self.name)
    }
    #hsh[:description] = self.description if !self.description.blank?
    hsh[:picture] = self.main_image.this_url if !self.main_image.nil?
    hsh
  end
  
  def category
    categories.first
  end
  
  def to_param
    self.id.to_s + '-' + self.name.parameterize
  end
  
  def can_delete?
    comments.count.eql?(0) && remembered_by.count.eql?(0)
  end
  # 
  # def destroy
  #   if deletion_validation
  #     super
  #   else
  #     false
  #   end
  # end
  
  
  def count_related_memories
    memories = Search.new(:term => self.name).results.where('memories.id != ?', self.id)
    self.related_memories_count = memories.count
    self.save
  end
  
  private
  def name_less_than_five_words
    errors.add(:name, "must be less than five words") if name.strip.split(' ').length > 5
  end
  
  def has_one_category
    errors.add(:base, "must have a Category") if !categories.length.eql?(1)
  end
  
  def share_to_facebook
    if Rails.env = "development"
      CONFIG[:app_url] = "http://47f6.localtunnel.com"
      CONFIG[:fb_invite] = "http://47f6.localtunnel.com/auth/facebook"
    end
    
    if share_on_facebook.eql?('1')
      fb_user = user.get_fb_user
      if fb_user
        fb_hsh = fb_share_hash
        Rails.logger.debug "[FACEBOOK MEMORY SHARED] #{File.basename(__FILE__)}[#{__LINE__}]: #{fb_hsh.to_yaml}"
        fb_user.feed!(
          fb_hsh
        )
      end
    end
  end
  
  def deletion_validation
    errors.add(:base, I18n.t('models.memory.deletion_validation')) unless can_delete?
    errors.blank?
  end
  
  def self.count_memoryby_userid(id)
    var = Memory.where('user_id >= ?', id).count
    return var
  end

  def self.get_memoryimages_by_userid(id)
    var = Memory.where('user_id >= ?', id).all(:limit => "3")
    return var
  end
  
  def timeline_on_facebook
    user = self.user
    app = FbGraph::Application.new(210370425684806)
    me = FbGraph::User.me(user.fb_auth_token)
    action = me.og_action!("CONFIG[]timeline", :memory => "http://47f6.localtunnel.com/memories/1560-mafalda-guille", :description => m.description, :start_time => m.timeline_date.iso8601, :end_time => m.timeline_date.iso8601)
  end
  

  
end
