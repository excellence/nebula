class CreateProposals < ActiveRecord::Migration
  def self.up
    create_table :proposals do |t|
      t.integer :state_id
      t.integer :state_change_id
      t.integer :character_id
      t.integer :user_id
      t.string :title
      t.text :body
      t.integer :votes, :default => 0
      t.timestamps
    end
    add_index :proposals, :votes
    add_index :proposals, :character_id
    add_index :proposals, :user_id
    add_index :proposals, :state_id
  end

  def self.down
    drop_table :proposals
  end
end
