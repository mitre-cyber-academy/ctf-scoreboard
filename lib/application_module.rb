# frozen_string_literal: true

# We have this module because it was relying on devise methods in a
# helper, which cannot be tested. Helpers do not extend active controller
# and do not have access to devise variables in tests.
#
# convention is to break out controller level 'helper methods' into a module
# and view 'helper methods' into a helper.
module ApplicationModule
  def user_logged_in?
    redirect_to root_path, alert: 'You must first login.' if current_user.nil?
  end

  def team_captain?
    !current_user.nil? && current_user.on_a_team? && current_user == current_user.team.team_captain
  end

  # This blocks admins from doing tasks that could leave the application in an inconsistent state, such as creating a
  # team or joining a team
  def block_admin_action
    redirect_back(fallback_location: root_path, alert: I18n.t('admin.should_not_do_action')) if current_user.admin?
  end
end
