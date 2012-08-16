class AddSystemPreferencesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :system_preferences, :integer, :default => 0
  end
end
