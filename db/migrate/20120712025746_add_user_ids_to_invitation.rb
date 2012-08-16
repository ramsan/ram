class AddUserIdsToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :host_user_id, :integer
  end
end
