class AddRelatedMemoriesCounterToMemory < ActiveRecord::Migration
  def change
    add_column :memories, :related_memories_count, :integer, :default => 0
  end
end
