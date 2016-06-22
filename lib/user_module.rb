# We have this module because it was relying on devise methods in a
# helper, which cannot be tested. Helpers do not extend active controller
# and do not have access to devise variables in tests.
#
# convention is to break out controller level 'helper methods' into a module
# and view 'helper methods' into a helper.
module UserModule
  def check_if_user_on_team
    redirect_to current_user.team, alert: I18n.t('teams.already_on_team_join') if current_user.on_a_team?
  end
end
