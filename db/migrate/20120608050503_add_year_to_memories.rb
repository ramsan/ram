class AddYearToMemories < ActiveRecord::Migration
  def change
    add_column :memories, :year, :date
  end
end
