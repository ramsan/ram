class Category < ActiveRecord::Base
  has_and_belongs_to_many :memories
  has_many :showdowns
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  #Header Image Uploading through Paperclip
  has_attached_file :header, :styles => {:normal => '980x160>', :thumb => "320x52>"}, :default => :normal,
    :storage => :s3,
    :s3_credentials => CONFIG[:amazon],
    :path => "/categories/header/:id/:style/:basename.:extension",
    :bucket => CONFIG[:amazon][:s3_bucket]
  
  scope :with_memories, all(:joins => :memories)
  scope :ordered, order("name ASC")
   
  def self.menu_items
    arel = Category.
    select('c.id, c.name, count(cm.memory_id) as memory_count').
    from('categories c, categories_memories cm').
    where('c.id=cm.category_id').
    group('cm.category_id').
    order('c.name asc')
    arel.collect{|record| [record.id, record.name, record.memory_count]}
  end
  
  def <=>(other)
    self.name <=> other.name
  end
  
  def to_param
    self.id.to_s + '-' + self.name.parameterize
  end
end
