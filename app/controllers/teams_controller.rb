class TeamsController < ApplicationController
  include ApplicationHelper

  helper_method :is_editable

  before_filter :is_logged_in

  before_filter :check_membership, only: [:show, :update, :destroy]

  def new
    if !current_user.on_a_team?
      @team = Team.new
    else
      redirect_to current_user.team, :alert => 'You cannot create a new team while already being a member of one.'
    end
  end

  def show
    @team = current_user.team
    # Filter for only pending invites and requests.
    @pending_invites = @team.user_invites.pending
    @pending_requests = @team.user_requests.pending
    if is_team_captain and !is_editable
      flash.now[:notice] = 'You have added all the users you can to your team.'
    end
  end

  def create
    @team = Team.new(team_params.merge(team_captain_id: current_user.id))
    if @team.save
      # Add current user to the team as team captain
      @team.users << current_user
      redirect_to @team, :notice => 'Team was successfully created.'
    else
      render :new
    end
  end

  def update
    team = current_user.team
    team.update_attributes(team_params)
    if team.save
      redirect_to team, :notice => 'Team member was successfully invited.'
    else
      redirect_to team, :alert => team.errors.full_messages.first
    end
  end

  def is_editable
    if (authenticate_user! and is_team_captain) and !@team.full?
      return true
    else
      return false
    end
  end

  def team_params
    params.require(:team).permit(:team_name, :affiliation, :user_invites_attributes => [:email])
  end

  private

  def is_logged_in
    if current_user.nil?
      redirect_to root_path, :alert => 'You must first login.'
    end
  end

  def check_membership
    # If the user is not signed in, not on a team, or not on the team they are trying to access
    # then deny them from accessing the team page.
    if !current_user.on_a_team? or (current_user.team_id != params[:id].to_i)
      redirect_to user_root_path, :alert => "You must first be a member of a team in order to view it."
    end
  end
end
