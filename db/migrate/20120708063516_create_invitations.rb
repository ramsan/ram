class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :fb_user
      t.string :fb_friend

      t.timestamps
    end
    add_index :invitations, :fb_user
    add_index :invitations, :fb_friend
  end
end
