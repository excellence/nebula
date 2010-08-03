class Corporation < ActiveRecord::Base
  belongs_to :alliance
  has_many :characters
  
  validates_presence_of :name
  validates_presence_of :ticker
  validates_length_of :name, :within => 1..100
  validates_length_of :ticker, :within => 1..5
end
