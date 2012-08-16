class AddImageCounterCacheColumnToMemory < ActiveRecord::Migration
  def self.up
    add_column :memories, :images_count, :integer, :default => 0
    
    Memory.reset_column_information
    Memory.all.each do |m|
      m.update_attribute :images_count, m.images.length
    end
  end
  
  def self.down
    remove_column :memories, :images_count
  end
end
