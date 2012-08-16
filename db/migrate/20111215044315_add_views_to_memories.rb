class AddViewsToMemories < ActiveRecord::Migration
  def change
    add_column :memories, :views, :integer, :default => 0
  end
end
