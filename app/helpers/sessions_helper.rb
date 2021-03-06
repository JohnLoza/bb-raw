module SessionsHelper
  # to manage sessions for user add the following in the migration
  # => t.string :password_digest
  # => t.string :remember_digest
  # and this to the model
  # => attr_accessor :remember_token

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.hash_id
  end # def log_in #

  def method
    session[:method] = 0
    return session[:method]
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember_token = Utils.new_token
    user.update_attributes(remember_digest: Utils.digest(user.remember_token))

    cookies.permanent.signed[:user_id] = user.hash_id
    cookies.permanent[:remember_token] = user.remember_token
  end # def remember #

  # Returns true if the given user is the current user.
  def current_user?(user)
    user.hash_id == current_user.hash_id
  end

  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(hash_id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(hash_id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Forgets a persistent session.
  def forget(user)
    user.update_attribute(:remember_digest, nil)
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current logged-in user
  def log_out
    if logged_in?
      forget current_user

      session.delete(:user_id)
      @current_user = nil
    end
  end # def log_out #

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

end
