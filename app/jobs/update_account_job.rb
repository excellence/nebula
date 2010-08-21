# Account update job. By default, queued onto the account_updates queue.
# Takes only one argument, the account ID
# Usually enqueued by Account#async_update!
class UpdateAccountJob
  @queue = :account_updates
  # Finds the specified account, and calls Account#update!
  def self.perform(account_id)
    account = Account.find_by_id(account_id)
    account.update!
  end
end