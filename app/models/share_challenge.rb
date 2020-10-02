# frozen_string_literal: true

class ShareChallenge < StandardChallenge
  include ShareCalculationModule
  include FlagChallengeShareModule

  validates :unsolved_increment_period, numericality: { greater_than: 0 }

  def start_calculation_at
    open_challenge_at || game&.start
  end

  def stop_calculation_at
    close_challenge_at || game&.stop
  end

  # Share Challenges do not have a concept of teams, however the FlagChallengeShareModule
  # requires us to return something for team
  def team
    nil
  end

  def calc_defensive_points_helper(_, _)
    0 # There are no defensive points in a Share Challenge
  end
end
