# frozen_string_literal: true

class FeedItem < ApplicationRecord
  belongs_to :team, optional: false
  belongs_to :user, optional: true
  belongs_to :challenge, optional: true
  belongs_to :division, optional: true

  scope :solved_challenges, -> { where(type: %w[PointSolvedChallenge PentestSolvedChallenge ShareSolvedChallenge])}

  validates :type, inclusion: %w[PointSolvedChallenge PentestSolvedChallenge ShareSolvedChallenge Achievement ScoreAdjustment]
end
