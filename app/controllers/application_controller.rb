# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrubs out any sensitive parameters in log files - note we don't filter API UID as this is useful for debugging and useless without a key
  filter_parameter_logging :password, :password_confirmation, :api_key, :key
end
