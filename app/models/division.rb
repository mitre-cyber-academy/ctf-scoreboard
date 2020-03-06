# frozen_string_literal: true

class Division < ApplicationRecord
  belongs_to :game, optional: false

  has_many :teams, dependent: :destroy
  has_many :feed_items, dependent: :destroy
  has_many :achievements, dependent: :destroy
  has_many :pentest_solved_challenges, dependent: :destroy
  has_many :point_solved_challenges, dependent: :destroy
  has_many :solved_challenges, inverse_of: :division, foreign_key: 'division_id', dependent: :destroy
  has_many :defense_flags, through: :teams

  validates :name, presence: true

  def ordered_teams(only_top_five = false)
    teams = calculate_team_scores
    # last_solve_time is added to the model by the calculate_point_solved_challenge_score method
    # teams.sort_by! { |team| [team.eligible, team.current_score, team.last_solve_time] }.reverse!
    teams.sort_by! { |team| [(team.eligible ? 1 : 0), team.current_score, team.last_solve_time] }.reverse!
    if only_top_five
      # Then take the first 5 elements in array
      teams[0..4]
    else
      teams
    end
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

  # TODO: Add sorting, add fallback sort on challenge last_solve if two
  # teams have the same score
  def calculate_team_scores
    team_standings = calculate_point_solved_challenge_score
    team_standings.merge_and_sum(calculate_pentest_solved_challenge_score)
    team_standings.map do |team, points|
      team.current_score = points.round
      team
    end
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
  # This calculates the teams score for all point-based challenges (PointSolvedChallenges and ScoreAdjustments)
  # This does not calculate the score for PentestChallenges
  def calculate_point_solved_challenge_score
    teams.includes(:achievements).joins(
      "LEFT JOIN feed_items AS point_feed_items
             ON point_feed_items.team_id = teams.id
             AND point_feed_items.type IN ('PointSolvedChallenge', 'ScoreAdjustment')
            LEFT JOIN feed_items AS pentest_feed_items
             ON pentest_feed_items.team_id = teams.id
             AND pentest_feed_items.type IN ('PentestSolvedChallenge')
            LEFT JOIN challenges ON challenges.id = point_feed_items.challenge_id"
    )
         .group('teams.id')
         .select(
           'COALESCE(sum(challenges.point_value), 0) + COALESCE(sum(point_feed_items.point_value), 0)
             as team_score,
           GREATEST(MAX(pentest_feed_items.created_at), MAX(point_feed_items.created_at)) as last_solve_time, teams.*'
         )
         .map do |team|
      [team, team.team_score]
    end.to_h
  end
  # rubocop:enable Metrics/MethodLength
end
