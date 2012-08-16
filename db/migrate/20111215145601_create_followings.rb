class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings, :id => false do |t|
      t.integer :followee_id
      t.integer :follower_id
    end
    
    add_index :followings, [:followee_id, :follower_id], :unique => true
  end
end
