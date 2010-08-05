class ChangeProposalVoteTotalCacheColumnName < ActiveRecord::Migration
  def self.up
    remove_index :proposals, :votes
    rename_column :proposals, :votes, :score
    add_index :proposals, :score
  end

  def self.down
  end
end
