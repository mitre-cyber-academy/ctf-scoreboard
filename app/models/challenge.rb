# frozen_string_literal: true

class Challenge < ApplicationRecord
  belongs_to :category, required: true
  has_many :flags, inverse_of: :challenge, dependent: :destroy
  has_many :solved_challenges, dependent: :destroy
  has_many :submitted_flags, dependent: :destroy

  enum state: { closed: 0, open: 1, force_closed: 2 }

  validates :name, :point_value, :flags, presence: true

  accepts_nested_attributes_for :flags, allow_destroy: true

  # Handles the ordering of all returned challenge objects.
  default_scope -> { order(:point_value, :name) }

  attr_accessor :submitted_flag

  # This bypasses game open check and only looks at the challenge state
  def challenge_open?
    state.eql? 'open'
  end

  def open?
    challenge_open? && category.game.open?
  end

  def solved?
    solved_challenges.count.positive?
  end

  def get_solved_challenge_for(team)
    solved_challenges.find_by(team: team)
  end

  # Returns whether or not challenge is available to be opened.
  def available?
    state.eql? 'closed'
  end

  def force_closed?
    state.eql? 'force_closed'
  end

  def state!(new_state)
    update(state: new_state)
  end

  def find_flag(flag_str)
    flags.find { |flag_obj| flag_obj.flag.casecmp(flag_str).zero? }
  end
end
