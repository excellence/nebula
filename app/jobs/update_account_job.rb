class UpdateAccountJob
  @queue = :account_updates
  def self.perform(account_id)
    account = Account.find_by_id(account_id)
    account.update!
  end
end