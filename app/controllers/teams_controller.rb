class TeamsController < ApplicationController
  include ApplicationHelper

  helper_method :team_editable?

  before_action :user_logged_in?

  before_action :check_membership, only: [:show, :update, :destroy]

  def new
    if !current_user.on_a_team?
      @team = Team.new
    else
      redirect_to current_user.team, alert: 'You cannot create a new team while already being a member of one.'
    end
  end

  def show
    @team = current_user.team
    # Filter for only pending invites and requests.
    @pending_invites = @team.user_invites.pending
    @pending_requests = @team.user_requests.pending
    flash.now[:notice] = 'You have added all the users you can to your team.' if team_captain? && !team_editable?
  end

  def create
    @team = Team.new(team_params.merge(team_captain_id: current_user.id))
    if @team.save
      # Add current user to the team as team captain
      @team.users << current_user
      redirect_to @team, notice: 'Team was successfully created.'
    else
      render :new
    end
  end

  def update
    team = current_user.team
    team.update_attributes(team_params)
    if team.save
      redirect_to team, notice: 'Team member was successfully invited.'
    else
      redirect_to team, alert: team.errors.map { |_, msg| msg }.join(', ')
    end
  end

  def team_editable?
    team_captain? && !@team.full?
  end

  def team_params
    params.require(:team).permit(:team_name, :affiliation, user_invites_attributes: [:email])
  end

  private

  def check_membership
    # If the user is not signed in, not on a team, or not on the team they are trying to access
    # then deny them from accessing the team page.
    if !current_user.on_a_team? || (current_user.team_id != params[:id].to_i)
      redirect_to user_root_path, alert: 'You must first be a member of a team in order to view it.'
    end
  end
end
