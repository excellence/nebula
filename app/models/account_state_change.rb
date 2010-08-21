class AccountStateChange < ActiveRecord::Base
  belongs_to :account
  belongs_to :account_state
end
