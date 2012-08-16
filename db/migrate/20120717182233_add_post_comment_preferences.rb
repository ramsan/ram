class AddPostCommentPreferences < ActiveRecord::Migration
  def change
    add_column :users, :fb_comment_preferences, :boolean, :default => false
  end
end
