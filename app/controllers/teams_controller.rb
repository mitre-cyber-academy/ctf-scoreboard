class TeamsController < ApplicationController
  include ApplicationHelper
  helper_method :is_editable
  def new
    @team = Team.new
    @team.users.build
  end
  def show
    @team = Team.find(params[:id])
    if is_team_captain and !is_editable
      flash.now[:notice] = 'You have added all the users you can to your team.'
    end
  end
  def create
    @team = Team.new(team_params)
    if @team.save
      redirect_to @team, :notice => 'Team was successfully created.'
    else
      render :action => "new"
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
    params.require(:team).permit(:team_name, :affiliation, users_attributes: [:email])
  end
end
