class AddVoteCountToProposals < ActiveRecord::Migration
  def self.up
    add_column :proposals, :enabled_votes, :integer, :default => 0
    add_index :proposals, :enabled_votes
  end

  def self.down
    remove_index :proposals, :enabled_votes
    remove_column :proposals, :enabled_votes
  end
end
