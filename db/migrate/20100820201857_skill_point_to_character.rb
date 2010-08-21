class SkillPointToCharacter < ActiveRecord::Migration
  def self.up
    add_column :characters, :skill_points, :integer
  end

  def self.down
  end
end
