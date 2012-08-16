class AddDecadeAndOtherFieldsToMemory < ActiveRecord::Migration
  def change
    add_column :memories, :decade, :integer, :limit => 1
    add_column :memories, :date_of_memory, :date
    add_column :memories, :is_anonymous, :boolean, :default => false
  end
end
