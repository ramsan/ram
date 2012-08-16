class AddGoogleFieldsToImages < ActiveRecord::Migration
  def change
    add_column :images, :google_thumb, :string
    add_column :images, :google_main, :string
  end
end
