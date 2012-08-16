class AddVotesCountCacheColumnsToUserAndShowdown < ActiveRecord::Migration
  def change
    add_column :users, :votes_count, :integer, :default => 0
    add_column :showdowns, :votes_count, :integer, :default => 0
  end
end
