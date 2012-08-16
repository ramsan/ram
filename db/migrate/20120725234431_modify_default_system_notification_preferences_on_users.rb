class ModifyDefaultSystemNotificationPreferencesOnUsers < ActiveRecord::Migration
  def up
  	change_column :users, :notification_preferences, :integer, :default => 7
  end

  def down
  	change_column :users, :notification_preferences, :integer, :default => 15
  end
end
