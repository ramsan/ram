class AddTagsToMemory < ActiveRecord::Migration
  def change
    add_column :memories, :tags, :string
    change_column :memories, :year, :string
  end
end
