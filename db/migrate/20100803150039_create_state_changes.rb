class CreateStateChanges < ActiveRecord::Migration
  def self.up
    create_table :state_changes do |t|
      t.integer :issue_id
      t.integer :from_state_id
      t.integer :to_state_id
      t.integer :user_id
      t.integer :character_id
      t.string :reason
      t.datetime :created_at
    end
    add_index :state_changes, :issue_id
    add_index :state_changes, :user_id
    add_index :state_changes, :character_id
  end

  def self.down
    drop_table :state_changes
  end
end
