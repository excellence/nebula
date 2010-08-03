class StateChange < ActiveRecord::Base
  belongs_to :issue
  belongs_to :from_state, :class_name => "State", :foreign_key => "from_state_id"
  belongs_to :to_state, :class_name => "State", :foreign_key => "to_state_id"
  belongs_to :user
  belongs_to :character
  validates_presence_of :reason, :on => :create, :message => "must be provided"
end
