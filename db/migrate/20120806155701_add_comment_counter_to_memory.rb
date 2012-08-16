class AddCommentCounterToMemory < ActiveRecord::Migration
  def change
    add_column :memories, :comments_count, :integer, :default => 0
  end
end
