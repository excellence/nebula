class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.database_authenticatable
      t.token_authenticatable
      t.activatable
      t.recoverable
      t.rememberable
      t.trackable
      t.lockable
      t.timestamps
    end
    add_index :users, :email, :unique => true
    add_index :users, :reset_password_token, :unique => true  
    add_index :users, :unlock_token, :unique => true  
  end
  def self.down
    drop_table :users
  end
end
