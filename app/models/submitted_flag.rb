# frozen_string_literal: true

class SubmittedFlag < ApplicationRecord
  belongs_to :user
  belongs_to :challenge
  belongs_to :team

  validates :text, presence: true
  validates :user_id, presence: true
  validates :challenge_id, presence: true

  before_validation :on_a_team?

  def on_a_team?
    throw :abort unless user&.on_a_team?
  end
end
