# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_nebula_session',
  :secret      => 'ff0d6fec7df84afijia571b233a14341d5d2b2d4f423655365003631d2b09431c642c5f613d5257jfiojfioewjiowerjiowerjwioerjASDASDLALSDKd8289ae90ac7c5a929477d28ab093a6a481e227ea5132a66dbfd112952b0269300c93806a9baf4dbc04c59c630a4ff8b0ff150a3e94c005b731'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
