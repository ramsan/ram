class AddAttachmentImageM1ImageM2ImageM3ImageM4ImageM5ToShowdown < ActiveRecord::Migration
  def self.up
    add_column :showdowns, :image_m1_file_name, :string
    add_column :showdowns, :image_m1_content_type, :string
    add_column :showdowns, :image_m1_file_size, :integer
    add_column :showdowns, :image_m1_updated_at, :datetime
    add_column :showdowns, :image_m2_file_name, :string
    add_column :showdowns, :image_m2_content_type, :string
    add_column :showdowns, :image_m2_file_size, :integer
    add_column :showdowns, :image_m2_updated_at, :datetime
    add_column :showdowns, :image_m3_file_name, :string
    add_column :showdowns, :image_m3_content_type, :string
    add_column :showdowns, :image_m3_file_size, :integer
    add_column :showdowns, :image_m3_updated_at, :datetime
    add_column :showdowns, :image_m4_file_name, :string
    add_column :showdowns, :image_m4_content_type, :string
    add_column :showdowns, :image_m4_file_size, :integer
    add_column :showdowns, :image_m4_updated_at, :datetime
    add_column :showdowns, :image_m5_file_name, :string
    add_column :showdowns, :image_m5_content_type, :string
    add_column :showdowns, :image_m5_file_size, :integer
    add_column :showdowns, :image_m5_updated_at, :datetime
  end

  def self.down
    remove_column :showdowns, :image_m1_file_name
    remove_column :showdowns, :image_m1_content_type
    remove_column :showdowns, :image_m1_file_size
    remove_column :showdowns, :image_m1_updated_at
    remove_column :showdowns, :image_m2_file_name
    remove_column :showdowns, :image_m2_content_type
    remove_column :showdowns, :image_m2_file_size
    remove_column :showdowns, :image_m2_updated_at
    remove_column :showdowns, :image_m3_file_name
    remove_column :showdowns, :image_m3_content_type
    remove_column :showdowns, :image_m3_file_size
    remove_column :showdowns, :image_m3_updated_at
    remove_column :showdowns, :image_m4_file_name
    remove_column :showdowns, :image_m4_content_type
    remove_column :showdowns, :image_m4_file_size
    remove_column :showdowns, :image_m4_updated_at
    remove_column :showdowns, :image_m5_file_name
    remove_column :showdowns, :image_m5_content_type
    remove_column :showdowns, :image_m5_file_size
    remove_column :showdowns, :image_m5_updated_at
  end
end
