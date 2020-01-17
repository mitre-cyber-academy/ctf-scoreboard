# frozen_string_literal: true

module SessionsHelper
  def deny_access
    redirect_to new_user_session_path, notice: I18n.t('users.login_required')
  end
end
