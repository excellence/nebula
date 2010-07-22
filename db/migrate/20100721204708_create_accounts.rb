class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.integer :user_id
      t.integer :character_id
      t.integer :api_uid
      t.string :encrypted_api_key
      t.boolean :validated, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
