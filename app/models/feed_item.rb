# frozen_string_literal: true

class FeedItem < ApplicationRecord
  belongs_to :team, optional: false
  belongs_to :user, optional: true
  belongs_to :challenge, optional: true
  belongs_to :division, optional: true

  validates :type, inclusion: %w[PointSolvedChallenge PentestSolvedChallenge Achievement ScoreAdjustment]

  def description
    self.class.name
  end

  def icon(icon)
    icon
  end
end
