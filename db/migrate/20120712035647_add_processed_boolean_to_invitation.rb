class AddProcessedBooleanToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :fb_processed_relationship, :boolean, :default => false
  end
end
