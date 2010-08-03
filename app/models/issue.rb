class Issue < ActiveRecord::Base
  belongs_to :state
  belongs_to :state_change
  belongs_to :character
  belongs_to :user
  validates_presence_of :title
  validates_presence_of :body
  validates_length_of :title, :within => 10..255
  validates_presence_of :state_id
  validates_presence_of :state_change_id
  validates_presence_of :character_id
  validates_presence_of :user_id
end
