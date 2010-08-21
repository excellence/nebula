class AddUserPrimaryCharacterFields < ActiveRecord::Migration
  def self.up
    add_column :users, :character_id, :integer
    add_column :users, :allow_character_id_change, :boolean, :default => true
  end

  def self.down
    remove_column :users, :character_id
    remove_column :users, :allow_character_id_change
  end
end
