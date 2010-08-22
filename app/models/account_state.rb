class AccountState < ActiveRecord::Base
  has_many :account_state_changes
end
