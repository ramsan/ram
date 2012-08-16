class AddIdToFollowings < ActiveRecord::Migration
  def self.up
    followings = Following.all.collect{|f| [f.follower_id, f.followee_id]}
    create_table :followings, :force => true do |t|
      t.integer :followee_id
      t.integer :follower_id
    end
    add_index :followings, [:followee_id, :follower_id], :unique => true
    
    followings.each do |f|
      Following.create!(:follower_id => f[0], :followee_id => f[1])
    end
  end
  
  def self.down
  end
end
