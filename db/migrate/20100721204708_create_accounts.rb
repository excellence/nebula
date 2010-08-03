class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.integer :user_id
      t.integer :character_id
      t.integer :api_uid
      t.string :encrypted_api_key
      t.boolean :validated, :default => false
      t.datetime :last_validated_at
      t.timestamps
    end
    add_index :accounts, :user_id
    add_index :accounts, :last_validated_at
    add_index :accounts, :validated
  end

  def self.down
    drop_table :accounts
  end
end
