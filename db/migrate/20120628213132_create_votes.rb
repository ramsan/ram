class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :showdown_id
      t.integer :user_id
      t.boolean :memory_1, :default => false
      t.boolean :memory_2, :default => false
      t.boolean :memory_3, :default => false
      t.boolean :memory_4, :default => false
      t.boolean :memory_5, :default => false

      t.timestamps
    end
    add_index :votes, :showdown_id
    add_index :votes, :user_id
  end
end
