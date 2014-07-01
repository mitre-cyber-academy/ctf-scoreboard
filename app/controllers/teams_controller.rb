class TeamsController < ApplicationController
  include ApplicationHelper
  before_filter :user_confirmed, only: :show
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
    @team = Team.new(params[:team])
    @team.users.first.skip_confirmation_notification!
    if @team.save
      @team.team_captain = @team.users.first
      if @team.save
        Devise::Mailer.confirmation_instructions(@team.users.first, @team.users.first.confirmation_token).deliver
        redirect_to :root, :notice => 'Team was successfully created. Please check your email to finish your registration.'
      else
        render :action => "new"
      end
    else
      render :action => "new"
    end
  end
  private
  def user_confirmed
    if !authenticate_user!
      redirect_to :root, :alert => "You must be logged in to access this resource."
    elsif !current_user.confirmed?
      redirect_to :root, :alert => "Please confirm your account first"
    elsif current_user.team_id.to_s != params[:id]
      raise ActionController::RoutingError.new('Not Found')
    else
      return true
    end
  end
  def is_editable
    if (authenticate_user! and is_team_captain) and @team.users.count < 5
      return true
    else
      return false
    end
  end
end
