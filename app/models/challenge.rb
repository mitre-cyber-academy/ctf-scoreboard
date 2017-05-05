# frozen_string_literal: true

class Challenge < ActiveRecord::Base
  belongs_to :category
  has_many :flags, inverse_of: :challenge
  has_many :solved_challenges
  has_many :submitted_flags

  enum state: %i[closed open force_closed]

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
    SolvedChallenge.where('challenge_id = :challenge', challenge: self).count.positive?
  end

  # Returns whether or not challenge is available to be opened.
  def available?
    state.eql? 'closed'
  end

  def force_closed?
    state.eql? 'force_closed'
  end

  def get_current_solved_challenge(user)
    solved_challenge = SolvedChallenge.where('challenge_id = :challenge and user_id = :user',
                                             challenge: self, user: user)
    solved_challenge&.first
  end

  def solved_by_user?(user)
    !get_current_solved_challenge(user).nil?
  end

  def get_video_url_for_flag(user)
    current_challenge = get_current_solved_challenge(user)
    current_challenge.flag.video_url unless current_challenge.nil? || current_challenge.flag.nil?
  end

  def get_api_request_for_flag(user)
    current_challenge = get_current_solved_challenge(user)
    current_challenge.flag.api_request unless current_challenge.nil? || current_challenge.flag.nil?
  end

  def set_state(new_state)
    challenge_state.state = new_state
    challenge_state.save
  end

  private
end
