class AddGooglePageUrlToImages < ActiveRecord::Migration
  def change
    add_column :images, :google_page_url, :string
  end
end
