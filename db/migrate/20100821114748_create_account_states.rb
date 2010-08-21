class CreateAccountStates < ActiveRecord::Migration
  def self.up
    create_table :account_states do |t|
      t.string :name
      t.text :description
      t.boolean :validated
    end
  end

  def self.down
    drop_table :account_states
  end
end
