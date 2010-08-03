class Character < ActiveRecord::Base
  belongs_to :corporation
  belongs_to :alliance
  belongs_to :account
  belongs_to :user
  has_many :issues
  
  validates_presence_of :user_id
  validates_presence_of :account_id
  validates_presence_of :corporation_id
  validates_presence_of :name
  validates_presence_of :bloodline
  validates_presence_of :race
  validates_presence_of :gender
  validates_length_of :name, :within => 1..35
  validates_length_of :bloodline, :within => 1..9
  validates_length_of :gender, :within => 1..6
  validates_length_of :race, :within => 1..8
end
