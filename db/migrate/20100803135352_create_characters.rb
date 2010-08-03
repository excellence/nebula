class CreateCharacters < ActiveRecord::Migration
  def self.up
    create_table :characters do |t|
      t.integer :user_id
      t.integer :account_id
      t.string :name, :length=>35
      t.integer :corporation_id
      t.integer :alliance_id
      t.string :gender, :limit=>6
      t.string :race, :limit=>8
      t.string :bloodline, :limit=>9
      t.timestamps
    end
    add_index :characters, :user_id
    add_index :characters, :account_id
  end

  def self.down
    drop_table :characters
  end
end
