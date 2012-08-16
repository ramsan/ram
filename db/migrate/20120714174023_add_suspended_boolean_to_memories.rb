class AddSuspendedBooleanToMemories < ActiveRecord::Migration
  def change
    add_column :memories, :suspended, :boolean, :default => false
  end
end
