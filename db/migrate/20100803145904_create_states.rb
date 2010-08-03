class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.string :name, :limit => 35
      t.string :description
    end
    add_index :states, :name
  end

  def self.down
    drop_table :states
  end
end
