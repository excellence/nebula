class RemoveVoteEnabledFlag < ActiveRecord::Migration
  def self.up
    remove_index :votes, :enabled
    remove_column :votes, :enabled
    rename_column :proposals, :enabled_votes, :votes_count
  end

  def self.down
    add_column :votes, :enabled
    add_index :votes, :enabled
    rename_column :proposals, :votes_count, :enabled_votes
  end
end
