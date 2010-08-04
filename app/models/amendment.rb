class Amendment < ActiveRecord::Base
  belongs_to :user
  belongs_to :character
  belongs_to :proposal
  belongs_to :approving_user, :class_name => "User", :foreign_key => "approving_user_id"
  belongs_to :approving_character, :class_name => "Character", :foreign_key => "approving_character_id"
end
