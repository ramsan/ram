class AddDemographicFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :birth_year, :integer
    add_column :users, :zip_code, :string
    add_column :users, :gender, :string
  end
end
