# frozen_string_literal: true

class Division < ApplicationRecord
  belongs_to :game, optional: false

  has_many :teams, dependent: :destroy
  has_many :feed_items, dependent: :destroy
  has_many :achievements, dependent: :destroy
  has_many :pentest_solved_challenges, dependent: :destroy
  has_many :standard_solved_challenges, dependent: :destroy
  has_many :solved_challenges, inverse_of: :division, dependent: :destroy
  has_many :defense_flags, through: :teams

  validates :name, presence: true

  def ordered_teams(only_top_five = false)
    teams = calculate_team_scores
    # last_solve_time is added to the model by the calculate_standard_solved_challenge_score method
    teams.sort_by! do |team|
      [(team.eligible ? 0 : 1), -team.current_score, team.last_solve_time || game.start]
    end

    return teams.take(5) if only_top_five

    teams
  end

  def ordered_teams_with_rank
    ordered_teams.each_with_index do |team, index|
      team.rank = index + 1
    end
  end

  # Returns an array of the appropriate years in school for the current division
  def acceptable_years_in_school
    Array(min_year_in_school..max_year_in_school)
  end

  private

  def calculate_team_scores
    team_standings = calculate_standard_solved_challenge_score
    team_standings.merge_and_sum(calculate_pentest_solved_challenge_score)
    team_standings.merge_and_sum(calculate_share_solved_challenge_score)
    team_standings.map do |team, points|
      team.current_score = points.round
      team
    end
  end

  def calculate_share_solved_challenge_score
    team_standings = {}
    game.standard_challenges.share_challenges.each do |challenge|
      team_standings.merge_and_sum(challenge.calc_points_for_solved_challenges)
    end
    team_standings
  end

  def calculate_pentest_solved_challenge_score
    # rubocop:disable Rails/FindEach
    # rubocop reports a false positive
    team_standings = {}
    defense_flags.preload(:solved_challenges).each do |flag|
      team_standings.merge_and_sum(flag.calc_points_for_solved_challenges)
    end
    team_standings
    # rubocop:enable Rails/FindEach
  end

  # rubocop:disable Metrics/MethodLength
  # This calculates the teams score for all point-based challenges (StandardSolvedChallenges and ScoreAdjustments)
  # This does not calculate the score for PentestChallenges
  def calculate_standard_solved_challenge_score
    teams.includes(:achievements).joins(
      "LEFT JOIN feed_items AS point_feed_items
             ON point_feed_items.team_id = teams.id
             AND point_feed_items.type IN ('StandardSolvedChallenge', 'ScoreAdjustment')
             LEFT JOIN feed_items AS pentest_feed_items
             ON pentest_feed_items.team_id = teams.id
             AND pentest_feed_items.type IN ('PentestSolvedChallenge')
             LEFT JOIN challenges ON challenges.id = point_feed_items.challenge_id
             AND challenges.type IN ('StandardChallenge')"
    )
         .group('teams.id')
         .select(
           'COALESCE(sum(challenges.point_value), 0) + COALESCE(sum(point_feed_items.point_value), 0)
             as team_score,
           GREATEST(MAX(pentest_feed_items.created_at), MAX(point_feed_items.created_at)) as last_solve_time, teams.*'
         )
         .index_with(&:team_score)
  end
  # rubocop:enable Metrics/MethodLength
end
