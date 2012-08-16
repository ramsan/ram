class CreateShowdowns < ActiveRecord::Migration
  def change
    create_table :showdowns do |t|
      t.string :question
      t.string :memory_1
      t.string :memory_2
      t.string :memory_3
      t.string :memory_4
      t.string :memory_5
      t.integer :user_id
      t.boolean :approved
      t.integer :approved_by
      t.date :approved_on

      t.timestamps
    end
    add_index :showdowns, :question
  end
end
