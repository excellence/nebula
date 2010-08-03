class CreateAlliances < ActiveRecord::Migration
  def self.up
    create_table :alliances do |t|
      t.string :name, :limit=>100
      t.string :ticker, :limit=>5
      t.integer :corporation_count
      t.integer :member_count
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :alliances
  end
end
