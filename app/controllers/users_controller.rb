class UsersController < ApplicationController
  include ApplicationHelper

  def join_team
    if !current_user.on_a_team?
      @user = current_user
      @pending_invites = @user.user_invites.pending
      @pending_requests = @user.user_requests.pending
    else
      redirect_to current_user.team, :alert => 'You cannot join another team while already being a member of one.'
    end
  end

  def leave_team
    # Only allow the team captain or the current user to remove the current user from a team.
    if (authenticate_user! and (is_team_captain or current_user.id.eql? params[:user_id].to_i))
      @team = Team.find(params[:team_id])
      @team.users.delete(params[:user_id])
      redirect_to @team, :notice => 'Player was successfully removed.'
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end