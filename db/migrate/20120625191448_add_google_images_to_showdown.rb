class AddGoogleImagesToShowdown < ActiveRecord::Migration
  def change
    add_column :showdowns, :image_1_google_thumb, :string
    add_column :showdowns, :image_1_google_main, :string
    add_column :showdowns, :image_1_google_page_url, :string
    add_column :showdowns, :image_2_google_thumb, :string
    add_column :showdowns, :image_2_google_main, :string
    add_column :showdowns, :image_2_google_page_url, :string
    add_column :showdowns, :image_3_google_thumb, :string
    add_column :showdowns, :image_3_google_main, :string
    add_column :showdowns, :image_3_google_page_url, :string
    add_column :showdowns, :image_4_google_thumb, :string
    add_column :showdowns, :image_4_google_main, :string
    add_column :showdowns, :image_4_google_page_url, :string
    add_column :showdowns, :image_5_google_thumb, :string
    add_column :showdowns, :image_5_google_main, :string
    add_column :showdowns, :image_5_google_page_url, :string
    add_index :showdowns, :image_1_google_thumb
    add_index :showdowns, :image_1_google_main
    add_index :showdowns, :image_1_google_page_url
    add_index :showdowns, :image_2_google_thumb
    add_index :showdowns, :image_2_google_main
    add_index :showdowns, :image_2_google_page_url
    add_index :showdowns, :image_3_google_thumb
    add_index :showdowns, :image_3_google_main
    add_index :showdowns, :image_3_google_page_url
    add_index :showdowns, :image_4_google_thumb
    add_index :showdowns, :image_4_google_main
    add_index :showdowns, :image_4_google_page_url
    add_index :showdowns, :image_5_google_thumb
    add_index :showdowns, :image_5_google_main
    add_index :showdowns, :image_5_google_page_url
  end
end
