class Comment < ActiveRecord::Base
  belongs_to :memory
  belongs_to :user
  
  validates_presence_of :memory, :user, :content
  validates_associated :memory, :user
  
  default_scope order("created_at DESC")
end
