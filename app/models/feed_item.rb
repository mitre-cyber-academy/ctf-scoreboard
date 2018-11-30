# frozen_string_literal: true

class FeedItem < ApplicationRecord
  belongs_to :team, required: true
  belongs_to :user, required: false
  belongs_to :challenge, required: false
  belongs_to :division, required: false

  validates :type, inclusion: %w[SolvedChallenge Achievement ScoreAdjustment]

  def description
    self.class
  end

  def icon
    ''
  end
end
