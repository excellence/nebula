# The User model represents one user on the system, who can have many accounts. 
# The Devise authentication framework is used for the majority of legwork this model does.
class User < ActiveRecord::Base
  devise :database_authenticatable, :token_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :activatable
  # attr_accessible sets attributes that can be accessed outside the model; keep this to the minimum for security.
  attr_accessible :email, :password, :password_confirmation
  # Return a friendly name by which to address this user in views. Defaults to email
  # TODO: Make this use a user's automatically (manually?) determined main character name.
  def name
    self.email
  end
end
