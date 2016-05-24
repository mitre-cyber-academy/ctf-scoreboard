class TeamsController < ApplicationController
  include ApplicationHelper
  helper_method :is_editable
  def new
    @team = Team.new
  end

  def show
    @team = Team.find(params[:id])
    # Filter for only pending invites and requests.
    @pending_invites = @team.user_invites.map {|invite| invite if invite.pending? }
    @pending_requests = @team.user_requests.map {|request| request if request.pending? }
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
end
