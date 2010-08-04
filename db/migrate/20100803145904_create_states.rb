class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.string :name, :limit => 35
      t.string :description
      t.boolean :can_vote, :default => true
      t.boolean :can_alter, :default => true
      t.boolean :show_in_lists, :default => true
    end
    add_index :states, :name
    add_index :states, :show_in_lists
  end

  def self.down
    drop_table :states
  end
end
