class CreateCorporations < ActiveRecord::Migration
  def self.up
    create_table :corporations do |t|
      t.string :name, :limit=>100
      t.string :ticker, :limit=>5
      t.integer :alliance_id
      t.integer :member_count
      t.datetime :updated_at
    end
    add_index :corporations, :alliance_id
  end

  def self.down
    drop_table :corporations
  end
end
