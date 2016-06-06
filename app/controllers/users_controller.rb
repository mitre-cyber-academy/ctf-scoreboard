class UsersController < ApplicationController
  include ApplicationHelper

  before_action :user_logged_in?
  before_action :check_removal_permissions, only: [:leave_team]

  def join_team
    if !current_user.on_a_team?
      @user = current_user
      @pending_invites = @user.user_invites.pending
      @pending_requests = @user.user_requests.pending
    else
      redirect_to current_user.team, alert: 'You cannot join another team while already being a member of one.'
    end
  end

  def leave_team
    @team = current_user.team
    @team.users.delete(params[:user_id])
    if current_user.team_captain?
      redirect_to @team, notice: 'Player was successfully removed.'
    else
      redirect_to join_team_users_path, notice: 'You have successfully left the team.'
    end
  end

  private

  # Only allow the team captain or the current user to remove the current user from a team.
  def check_removal_permissions
    raise ActiveRecord::RecordNotFound unless team_captain? || current_user.id.eql?(params[:user_id].to_i)
  end
end
