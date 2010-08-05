# An account represents an EVE Online account, with one or more characters on that account.
# This account also stores the API key and user ID used to validate that account.
# API key is stored encrypted using the attr_encrypted gem. Symmetric key used to encrypt the keys is defined in config/initializers/encryption.rb and is defined as API_KEY_ENCRYPTION_KEY
class Account < ActiveRecord::Base
  
  attr_accessible :api_key, :api_uid, :character_id
  attr_encrypted :api_key, :key=>API_KEY_ENCRYPTION_KEY, :encode => true
  
  belongs_to :user
  belongs_to :character
  has_many :votes
  
  validates_presence_of :user_id
  validates_presence_of :api_key
  validates_length_of :api_key, :is=>64
  validates_presence_of :api_uid
  validates_numericality_of :api_uid
  validates_presence_of :character_id
  validates_numericality_of :character_id
end
