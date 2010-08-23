namespace :nebula do
  namespace :api do
    desc 'Enqueue updates for all accounts which have not been validated in the last 3 days'
    task :update_accounts => :environment do
      # Do not select where last_validated_at is null; this picks up all the accounts that have never validated okay, which we only want to update through triggers.
      Account.find(:all, :conditions => ['last_validated_at > ?', Time.now-3.days]).each do |account|
        account.async_update! # Enqueue the update
      end
    end
  end
end