class CreateAccountStateChanges < ActiveRecord::Migration
  def self.up
    create_table :account_state_changes do |t|
      t.integer :account_id
      t.integer :account_state_id
      t.datetime :created_at
    end
    add_column :accounts, :account_state_id, :integer
  end

  def self.down
    drop_table :account_state_changes
  end
end
