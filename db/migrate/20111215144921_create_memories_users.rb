class CreateMemoriesUsers < ActiveRecord::Migration
  def change
    create_table :memories_users, :id => false do |t|
      t.integer :memory_id
      t.integer :user_id
    end
  end
end
