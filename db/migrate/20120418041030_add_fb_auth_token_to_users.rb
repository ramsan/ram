class AddFbAuthTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fb_auth_token, :string
  end
end
