class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :proposal_id
      t.integer :user_id
      t.integer :character_id
      t.integer :account_id
      t.integer :value
      t.integer :enabled, :default => true
      t.timestamps
    end
    add_index :votes, :enabled
    add_index :votes, :proposal_id
    add_index :votes, :proposal_id, :account_id, :unique => true
    add_index :votes, :user_id
    add_index :votes, :account_id
  end

  def self.down
    drop_table :votes
  end
end
