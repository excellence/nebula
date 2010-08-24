# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrubs out any sensitive parameters in log files - note we don't filter API UID as this is useful for debugging and useless without a key
  filter_parameter_logging :password, :password_confirmation, :api_key, :key
  
  # Helper method, requires that the user have a primary character set up, redirects them to their EVE account management page if they don't.
  def require_primary_character!
    if !authenticate_user! || !current_user.character
      flash[:error] = "You must have a validated EVE Online account to perform this action."
      redirect_to '/accounts/'
      return false
    end
  end
end
