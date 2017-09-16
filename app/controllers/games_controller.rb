# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :load_users_and_divisions, only: %i[summary teams]
  before_action :load_game_for_show_page, only: %i[show]
  before_action :filter_access_before_game_open
  before_action :load_message_count

  def show
    @challenges = @game&.challenges
    @categories = @game&.categories
    @solved_challenges = current_user&.team&.solved_challenges&.map(&:challenge_id)
  end

  def summary
    @user_locations = User.where('country IS NOT NULL').group(:country).count
    @flags_per_hour = SubmittedFlag.group_by_hour(:created_at).count
    @line_chart_data = [
      { name: 'Flag Submissions', data: @flags_per_hour },
      { name: 'Challenges Solved', data: SolvedChallenge.group_by_hour(:created_at).count }
    ]
    @page_requires_gcharts = true
    @view_all_teams_link = true
  end

  def load_game_for_show_page
    @game = Game.includes(:categories).includes(:challenges).instance
  end

  def load_users_and_divisions
    @game = Game.includes(:divisions).instance
    @divisions = @game.divisions
    signed_in_not_admin = !current_user&.admin?
    @active_division = signed_in_not_admin && current_user&.team ? current_user&.team&.division : @divisions.first
  end
end
