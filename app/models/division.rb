# frozen_string_literal: true

class Division < ActiveRecord::Base
  belongs_to :game
  has_many :teams, dependent: :destroy
  has_many :feed_items
  has_many :achievements

  validates :name, presence: true

  def ordered_players(only_top_five = false)
    # They are eligible if the boolean is true
    teams = filter_and_sort_teams(eligible: true)
    # They are ineligible if the boolean is false
    ineligible_teams = filter_and_sort_teams(eligible: false)
    # Take the eligible teams [in whole competition] and appends
    # the ineligible teams to the end of the array of eligible teams
    teams.concat(ineligible_teams)
    # if true return the first five in array
    if only_top_five
      # Then take the first 5 elements in array
      teams[0..4]
    else
      teams
    end
  end

  private

  def add_states_to_challenges
    Challenge.all.find_each do |c|
      ChallengeState.create!(challenge: c, division: self, state: c.starting_state)
    end
  end

  # rubocop:disable MethodLength
  # Sorts the provided list of players. This sorts directly in the database instead of getting the
  # data out of the database and sorting in rails. It gets all feed items of type ScoreAdjustment
  # and SolvedChallenge and sums up their values or the value of the challenge in the case of a
  # SolvedChallenge.
  def filter_and_sort_teams(filters)
    teams.includes(:achievements).where(filters)
           .joins(
             "LEFT JOIN feed_items
               ON feed_items.team_id = teams.id
               AND feed_items.type IN ('SolvedChallenge', 'ScoreAdjustment')
             LEFT JOIN challenges ON challenges.id = feed_items.challenge_id"
           )
           .group('teams.id')
           .select(
             'COALESCE(sum(challenges.point_value), 0) + COALESCE(sum(feed_items.point_value), 0)
               as current_score,
             MAX(feed_items.created_at) as last_solved_date, teams.*'
           )
           .order('current_score desc', 'last_solved_date asc', 'display_name asc')
  end
  # rubocop:enable MethodLength
end
