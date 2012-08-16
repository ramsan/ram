class AddNotificationPreferencesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notification_preferences, :integer, :default => 15
  end
end
