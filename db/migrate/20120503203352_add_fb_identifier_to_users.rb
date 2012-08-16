class AddFbIdentifierToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fb_identifier, :string
  end
end
