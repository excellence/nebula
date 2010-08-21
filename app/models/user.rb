# The User model represents one user on the system, who can have many accounts. 
# The Devise authentication framework is used for the majority of legwork this model does.
class User < ActiveRecord::Base
  devise :database_authenticatable, :token_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :activatable
  
  has_many :accounts
  has_many :characters
  has_many :proposals
  has_many :amendments
  has_many :state_changes
  has_many :votes
  belongs_to :character
  
  # attr_accessible sets attributes that can be accessed outside the model; keep this to the minimum for security.
  attr_accessible :email, :password, :password_confirmation
  # Return a friendly name by which to address this user in views. Defaults to email
  # TODO: Make this use a user's automatically (manually?) determined main character name.
  def name
    self.email
  end
end
