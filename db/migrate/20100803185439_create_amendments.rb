class CreateAmendments < ActiveRecord::Migration
  def self.up
    create_table :amendments do |t|
      t.integer :proposal_id
      t.integer :user_id
      t.integer :character_id
      t.string :title
      t.text :body
      t.boolean :approved, :default => false
      t.integer :approving_user_id
      t.integer :approving_character_id
      t.timestamps
    end
    add_index :amendments, :proposal_id
    add_index :amendments, :character_id
    add_index :amendments, :user_id
    
  end

  def self.down
    drop_table :amendments
  end
end
