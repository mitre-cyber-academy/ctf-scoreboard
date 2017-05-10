# frozen_string_literal: true

module SessionsHelper
  def deny_access
    store_location
    redirect_to new_user_session_path, notice: I18n.t('users.login_required')
  end

  private

  def store_location
    session[:return_to] = request.fullpath
  end

  def clear_stored_location
    session[:return_to] = nil
  end
end
