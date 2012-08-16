class RenameUsersImageToProfileImage < ActiveRecord::Migration
  def change
    rename_column :users, :image_file_name, :profile_image_file_name
    rename_column :users, :image_content_type, :profile_image_content_type
    rename_column :users, :image_file_size, :profile_image_file_size
    rename_column :users, :image_updated_at, :profile_image_updated_at  
  end
end
