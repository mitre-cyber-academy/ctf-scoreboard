# Contains basic methods for checking if a user is logged in and a team captain.
module ApplicationHelper
  def user_logged_in?
    redirect_to root_path, alert: 'You must first login.' if current_user.nil?
  end

  def team_captain?
    !current_user.nil? && current_user.on_a_team? && current_user == current_user.team.team_captain
  end
end
