class ChangeFbComment < ActiveRecord::Migration
  def change
    rename_column :users, :fb_comment_preferences, :comment_preferences
  end
end
