class AddMemoriesCounterToShowdown < ActiveRecord::Migration
  def change
    add_column :showdowns, :memory_1_votes_count, :integer, :default => 0
    add_column :showdowns, :memory_2_votes_count, :integer, :default => 0
    add_column :showdowns, :memory_3_votes_count, :integer, :default => 0
    add_column :showdowns, :memory_4_votes_count, :integer, :default => 0
    add_column :showdowns, :memory_5_votes_count, :integer, :default => 0
    
    #adding indexes 
    add_index :showdowns, :memory_1_votes_count
    add_index :showdowns, :memory_2_votes_count
    add_index :showdowns, :memory_3_votes_count
    add_index :showdowns, :memory_4_votes_count
    add_index :showdowns, :memory_5_votes_count
  end
  
end