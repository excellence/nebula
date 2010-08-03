class Alliance < ActiveRecord::Base
  has_many :corporations
  
  validates_presence_of :name
  validates_presence_of :ticker
  validates_length_of :name, :within => 3..100
  validates_length_of :ticker, :within => 1..5
  
end
