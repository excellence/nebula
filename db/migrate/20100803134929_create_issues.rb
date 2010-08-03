class CreateIssues < ActiveRecord::Migration
  def self.up
    create_table :issues do |t|
      t.integer :state_id
      t.integer :state_change_id
      t.integer :character_id
      t.integer :user_id
      t.string :title
      t.text :body
      t.integer :votes, :default => 0
      t.timestamps
    end
    add_index :issues, :votes
    add_index :issues, :character_id
    add_index :issues, :user_id
    add_index :issues, :state_id
  end

  def self.down
    drop_table :issues
  end
end
