class AddIndexToMemoriesUsers < ActiveRecord::Migration
  def change
    add_index :memories_users, [:memory_id, :user_id], :unique => true
  end
end
