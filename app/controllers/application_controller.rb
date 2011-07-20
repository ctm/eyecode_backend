class ApplicationController < ActionController::Base
  # TODO: convert to use Rails 3.1 SSL stuff.
  # include SslRequirement

# SWCP doesn't currently allow us to use https, so the following line is
# commented out.

#  ssl_exceptions # by default use SSL everywhere, so eavesdroppers can't
                 # hijack sessions
  helper :all # include all helpers, all the time
  protect_from_forgery

  helper_method :current_user_session, :current_user

  protected

  # Useful for the common case of wanting to set some attributes to
  # values coming from params, where the attributes themselves are
  # protected from mass assignment.  +key+ is the top-level key for
  # params.  +attrs+ are the protected attributes whose values need to
  # be extracted from <tt>params[key]</tt>.
  # +update_protected_attrs_from_params+ executes the block that is
  # supplied, passing in the value of <tt>params[key]</tt> with the
  # protected attributes (+attrs+) removed.  This block returns an
  # object, and each of the protected attributes are then set on that
  # object.
  #
  # For example,
  #
  #   update_protected_attrs_from_params(:user, :login) do |p|
  #     @user = User.new(p)
  #   end
  #
  # will result in <tt>User.new</tt> being called with the value of
  # <tt>params[:user]</tt>, minus the value of
  # <tt>params[:user][:login]</tt>, but if
  # <tt>params[:user][:login]</tt> exists, <tt>@user.login</tt> will
  # be set to the value of <tt>params[:user][:login]</tt> even if the
  # +login+ attribute of the User model is protected.
  #
  # Similarly,
  #
  #   update_protected_attrs_from_params(:user, :login, :active) do |p|
  #     @user.attributes = p
  #     @user
  #   end
  #
  # will invoke <tt>@user.attributes = </tt> with the contents of
  # <tt>params[:user]</tt> minus <tt>params[:user][:login]</tt> and
  # <tt>params[:user][:active]</tt>, but if
  # <tt>params[:user][:login]</tt> is available, it will be used to
  # update <tt>@user.login</tt> and if <tt>params[:user][:active]</tt> is
  # available, it will be used to update <tt>@user.active</tt>.

  def update_protected_attrs_from_params(key, *attrs, &blk)
    protected_params = {}
    params_minus_protected = params[key]
    if params_minus_protected.kind_of?(Hash)
      params_minus_protected = params_minus_protected.dup
      for attr in attrs
        if params_minus_protected.has_key?(attr)
          protected_params[attr] = params_minus_protected.delete(attr)
        end
      end
    end
    obj = yield(params_minus_protected)
    obj.send(:attributes=, protected_params, false)
    return obj
  end

  private

  def current_user_session
    if !defined?(@current_user_session)
      @current_user_session = UserSession.find
      set_time_zone_from_session(@current_user_session)
    end
    return @current_user_session
  end

  def set_time_zone_from_session(session)
    tz = session && session.user && session.user.time_zone
    Time.zone = tz unless tz.blank?
  end
  
  def current_user
    if !defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
    return @current_user
  end

  # returns true if the current user is an admin, false otherwise
  def admin?
    return !!current_user && current_user.admin?
  end

  def require_user
    save_notify_and_redirect 'You must be logged in to access this page.' unless current_user
  end

  def require_no_user
    save_notify_and_redirect 'You must be logged out to access this page.', user_url if current_user
  end

  def require_admin
    require_user
    save_notify_and_redirect 'You must be an admin to access this page.', root_url unless before_filters_halted? || admin?
  end

  def save_notify_and_redirect(message, to_url = new_user_session_url)
    session[:return_to] = request.path
    flash[:notice] = message
    redirect_to to_url
  end

  def redirect_back_or_default(default = root_url)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  # Ugly code that peers inside Rails's implementation to do its work, but
  # in my mind it's cleaner to have a method (whose implementation may break
  # as Rails changes) to return whether the filter chain has been halted than
  # to make our own filters use both the Rails way to signal that a chain has
  # been halted (by doing a rendor or redirect) and also return a value that
  # provides the same thing (e.g. return false if we want the chain halted).

  def before_filters_halted?
    return performed?
  end
end
