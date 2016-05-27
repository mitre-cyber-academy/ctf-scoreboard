class TeamsController < ApplicationController
  include ApplicationHelper
  helper_method :is_editable

  before_filter :check_membership, only: [:show, :update, :destroy]

  def new
    if current_user.team.nil?
      @team = Team.new
    else
      redirect_to current_user.team, :alert => 'You cannot create a new team while already being a member of one.'
    end
  end

  def show
    @team = Team.find(params[:id])
    # Filter for only pending invites and requests.
    @pending_invites = @team.user_invites.pending
    @pending_requests = @team.user_requests.pending
    if is_team_captain and !is_editable
      flash.now[:notice] = 'You have added all the users you can to your team.'
    end
  end

  def create
    @team = Team.new(team_params)
    # When creating a new team, make the user creating the team the captain
    @team.users << current_user
    @team.team_captain = current_user

    if @team.save
      redirect_to @team, :notice => 'Team was successfully created.'
    else
      render :action => "new"
    end
  end

  def update
    team = Team.find(params[:id])
    team.update_attributes(team_params)
    if team.save
      redirect_to team, :notice => 'Team member was successfully invited.'
    else
      redirect_to team, :alert => team.errors.full_messages.first
    end
  end

  def is_editable
    if (authenticate_user! and is_team_captain) and @team.users.count < 5
      return true
    else
      return false
    end
  end

  def team_params
    params.require(:team).permit(:team_name, :affiliation, :user_invites_attributes => [:email])
  end

  private

  def check_membership
    # If the user is not signed in, not on a team, or not on the team they are trying to access
    # then deny them from accessing the team page.
    if current_user.nil? or current_user.team.nil? or (current_user.team_id != params[:id].to_i)
      redirect_to join_team_users_path
    end
  end
end
