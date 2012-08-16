class Vote < ActiveRecord::Base
  
  #Securing the Content
  attr_accessible :showdown_id, :user_id, :memory_1, :memory_2, :memory_3, :memory_4, :memory_5
  
  #Associations
  belongs_to :user, :counter_cache => true
  belongs_to :showdown, :counter_cache => true
  
  #Validations
  validates_uniqueness_of :user_id, :scope => :showdown_id, :message => "has already voted on this showdown"
  
  
  
end
