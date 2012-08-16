class AddUserAndCaptionToImages < ActiveRecord::Migration
  def change
    add_column :images, :caption, :text
    add_column :images, :user_id, :integer
  end
end
