class AddCategoriesAndDecadesToShowdown < ActiveRecord::Migration
  def change
    add_column :showdowns, :category_id, :integer
    add_column :showdowns, :decade, :integer
  end
end
