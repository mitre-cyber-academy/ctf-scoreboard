# frozen_string_literal: true

class FeedItem < ActiveRecord::Base
  belongs_to :team, required: true
  belongs_to :user
  belongs_to :challenge
  belongs_to :division

  validates :type, inclusion: %w[SolvedChallenge Achievement ScoreAdjustment]

  def description
    self.class
  end

  def icon
    ''
  end
end
