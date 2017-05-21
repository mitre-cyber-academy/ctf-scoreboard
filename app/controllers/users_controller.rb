# frozen_string_literal: true

class UsersController < ApplicationController
  include ApplicationModule
  include UserModule
  include UserHelper

  before_action :user_logged_in?
  before_action :load_game, :load_message_count
  before_action :check_removal_permissions, only: [:leave_team]
  before_action :check_if_user_on_team, only: [:join_team]
  before_action :check_promote_permissions, only: [:promote]

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable MethodLength
  def join_team
    @pending_invites = current_user.user_invites.pending
    @pending_requests = current_user.user_requests.pending
    (@filterrific = initialize_filterrific(
      Team, params[:filterrific],
      select_options: { location: us_states, division: Division.all.map { |d| [d.name, d.id] } }
    )) || return
    @teams = @filterrific.find.includes(:division).page(params[:page])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def leave_team
    @team = current_user.team
    is_current_captain = @team.team_captain&.id.eql?(params[:user_id].to_i)

    if is_current_captain && @team.users.size > 1
      redirect_to @team, alert: I18n.t('teams.captain_must_promote')
    else
      @team.users.delete(params[:user_id])
      if current_user.team_captain? && !is_current_captain
        redirect_to @team, notice: I18n.t('teams.captain_removed_player')
      else
        @team.cleanup
        redirect_to join_team_users_path, notice: I18n.t('teams.player_removed_self')
      end
    end
  end

  # rubocop:enable Metrics/AbcSize
  # rubocop:enable MethodLength

  def promote
    @team = current_user.team
    @team.promote(params[:user_id])
    redirect_to @team, notice: I18n.t('teams.promoted_captain')
  end

  private

  # Only allow the team captain or the current user to remove the current user from a team.
  def check_removal_permissions
    raise ActiveRecord::RecordNotFound unless team_captain? || current_user.id.eql?(params[:user_id].to_i)
  end

  def check_promote_permissions
    raise ActiveRecord::RecordNotFound unless team_captain?
  end
end
