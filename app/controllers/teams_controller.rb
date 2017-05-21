# frozen_string_literal: true

class TeamsController < ApplicationController
  include ApplicationModule

  helper_method :team_editable?
  before_action :user_logged_in?
  before_action :load_game, :load_message_count
  before_action :block_admin_action, only: [:create]
  before_action :check_membership, only: %i[update destroy]
  before_action :check_membership_show, only: [:show]

  def new
    if !current_user.on_a_team?
      @team = Team.new
    else
      redirect_to current_user.team, alert: I18n.t('teams.already_on_team_create')
    end
  end

  def show
    @team_captain = team_captain?
    @team = Team.find_by(id: params[:id].to_i)
    # Filter for only pending invites and requests.
    @pending_invites = @team.user_invites.pending
    @pending_requests = @team.user_requests.pending
    # Show this information if the user is not a member
    @page_requires_gcharts = true
    @solved_challenges = @team&.solved_challenges
    @flags_per_hour = @team.submitted_flags.group_by_hour('submitted_flags.created_at').count
    @user_locations = @team.users.where('country IS NOT NULL').group(:country).count
    flash.now[:notice] = I18n.t('teams.full_team') if team_captain? && !team_editable?
  end

  def create
    @team = Team.new(team_params.merge(team_captain_id: current_user.id))
    if @team.save
      # Add current user to the team as team captain
      @team.users << current_user
      redirect_to @team, notice: I18n.t('teams.create_successful')
    else
      render :new
    end
  end

  def update
    team = current_user.team
    team.update_attributes(team_params)
    if team.save
      redirect_to team, notice: I18n.t('invites.invite_successful')
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

  def check_membership_show
    redirect_to user_root_path, alert: I18n.t('teams.must_be_on_team') unless current_user.on_a_team?
    @membership = current_user.team_id == params[:id].to_i
  end

  def check_membership
    # If the user is not signed in, not on a team, or not on the team they are trying to access
    # then deny them from accessing the update and create actions on a team page.
    return true unless !current_user.on_a_team? || (current_user.team_id != params[:id].to_i)
    redirect_to user_root_path, alert: I18n.t('teams.invalid_permissions')
  end
end
