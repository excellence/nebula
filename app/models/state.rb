class State < ActiveRecord::Base
  has_many :issues
  has_many :changes_from_state, :class_name => "StateChange", :foreign_key => "from_state_id"
  has_many :changes_to_state, :class_name => "StateChange", :foreign_key => "to_state_id"
  validates_presence_of :name
  validates_length_of :name, :within => 0..35
  validates_presence_of :description
end
