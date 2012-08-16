class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.string :email
      t.string :ip

      t.timestamps
    end
  end
end
