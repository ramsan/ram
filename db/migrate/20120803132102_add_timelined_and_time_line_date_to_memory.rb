class AddTimelinedAndTimeLineDateToMemory < ActiveRecord::Migration
  def change
    add_column :memories, :timelined, :boolean, :default => false
    add_column :memories, :timeline_date, :date
  end
end
