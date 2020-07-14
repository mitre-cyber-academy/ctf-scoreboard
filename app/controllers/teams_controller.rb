# frozen_string_literal: true

class TeamsController < ApplicationController
  include ApplicationModule

  helper_method :team_editable?
  before_action :user_logged_in?, except: %i[summary]
  before_action :load_game, :load_message_count
  before_action :block_admin_action, only: [:create]
  before_action :check_user_on_team, only: %i[new create]
  before_action :check_membership, only: %i[show update destroy]
  before_action :check_team_captain, :load_user_team, only: %i[update edit invite]
  before_action :prevent_action_after_game, except: %i[index show summary]
  before_action :deny_team_in_top_ten, :update_team, only: %i[update invite]
  before_action :load_team, only: %i[show summary]
  before_action :load_admin_stats, only: %i[summary]
  before_action :load_categories, only: %i[summary]

  def index; end

  def summary
    @score_adjustments = @team.score_adjustments
    prepare_team_flag_submissions
  end

  def prepare_team_flag_submissions
    @team_flag_submissions = [
      {
        name: I18n.t('game.summary.flag_submissions_graph.flags_submitted'),
        data: @team.submitted_flags_per_hour(@game.graph_group_method)
      },
      {
        name: I18n.t('game.summary.flag_submissions_graph.challenges_solved'),
        data: @team.solved_challenges_per_hour(@game.graph_group_method)
      }
    ]
  end

  def destroy; end

  def new
    @team = Team.new
    @divisions = Division.all
  end

  def show
    @team_captain = team_captain?
    # Filter for only pending invites and requests.
    @pending_invites = @team.user_invites.pending
    @pending_requests = @team.user_requests.pending
    @solved_challenges = @team.solved_challenges
    flash.now[:notice] = I18n.t('teams.full_team') if @team.full?
    summary
  end

  def create
    @team = Team.new(team_params.merge(team_captain_id: current_user.id))
    if @team.save
      redirect_to @team, notice: I18n.t('teams.create_successful')
    else
      redirect_to new_team_path, alert: @team.errors.full_messages.flatten
    end
  end

  def edit
    @divisions = Division.all
  end

  def update
    if @team.save
      redirect_to @team, notice: I18n.t('teams.update_successful')
    else
      redirect_to edit_team_path(@team), alert: @team.errors.full_messages.map { |msg| msg }.join(', ')
    end
  end

  def invite
    if @team.save
      redirect_to @team, notice: I18n.t('invites.invite_successful')
    else
      redirect_to team_path(@team), alert: @team.errors.messages.map { |_, msg| msg }.join(', ')
    end
  end

  def team_editable?
    team_captain? && !@team.full?
  end

  def team_params
    params.require(:team).permit(:team_name, :affiliation, :division_id, user_invites_attributes: [:email])
  end

  private

  def load_categories
    @defensive_points = @team.calc_defensive_points
    @flag_categories = @team.solves_by_category
  end

  def check_team_captain
    redirect_to user_root_path, alert: I18n.t('teams.must_be_team_captain') unless current_user.team_captain?
  end

  def check_user_on_team
    redirect_to current_user.team, alert: I18n.t('teams.already_on_team_create') if current_user.on_a_team?
  end

  def check_membership
    # If the user is not signed in, not on a team, or not on the team they are trying to access
    # then deny them from accessing the update and create actions on a team page.
    return true unless !current_user.on_a_team? || (current_user.team_id != params[:id].to_i)

    redirect_to user_root_path, alert: I18n.t('teams.invalid_permissions')
  end

  # The code for inviting a user and updating a team is exactly the same, except for the actual
  # notice displayed. This allows us to preload some information for both methods without duplication.
  def update_team
    @team.update(team_params)
  end

  def load_team
    @team = Team.find_by(id: params[:id].to_i)
    @solved_challenges = @team.solved_challenges
    redirect_back(fallback_location: game_summary_path, alert: I18n.t('teams.does_not_exist')) unless @team
  end

  def load_admin_stats
    return unless current_user&.admin?

    @per_user_stats =
      [{
        name: I18n.t('game.summary.flag_submissions_graph.flags_submitted'),
        data: @team.submitted_flags.joins(:user).group('users.full_name').count
      },
       {
         name: I18n.t('game.summary.flag_submissions_graph.challenges_solved'),
         data: @team.solved_challenges.joins(:user).group('users.full_name').count
       }]
  end

  def load_user_team
    @team = current_user.team
  end
end
