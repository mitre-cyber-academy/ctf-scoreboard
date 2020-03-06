# frozen_string_literal: true

class ShareChallenge < StandardChallenge
  include ShareCalculationModule
  include FlagChallengeShareModule

  validates :unsolved_increment_period, numericality: { greater_than: 0 }

  def calc_defensive_points_helper(_, _)
    0 # There are no defensive points in a Share Challenge
  end
end
