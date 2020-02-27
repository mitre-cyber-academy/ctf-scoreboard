# frozen_string_literal: true

class Challenge < ApplicationRecord
  # TODO: Add validator that verifies a challenge only has one category if the parent game is in JeopardyGame mode
  before_save :post_state_change_message

  belongs_to :game

  has_many :challenge_categories, dependent: :destroy
  has_many :categories, through: :challenge_categories

  has_many :submitted_flags, dependent: :destroy

  enum state: { closed: 0, open: 1, force_closed: 2 }

  validates :name, :point_value, presence: true

  # Handles the ordering of all returned challenge objects.
  default_scope -> { order(:point_value, :name) }

  attr_accessor :submitted_flag, :solved_challenges_count

  def self.type_enum
    [['PentestChallenge'], ['ShareChallenge'], ['PointChallenge']]
  end

  validates :type, inclusion: type_enum.flatten, presence: true

  # This bypasses game open check and only looks at the challenge state
  def challenge_open?
    state.eql? 'open'
  end

  def open?
    challenge_open? && game.open?
  end

  def solved?(times = 1)
    # We sometimes define solved_challenges_count using the
    # activerecord preloader gem. If we have done this then
    # we should utilize that count, if not then we should fall
    # through and use the regular old count method.
    (solved_challenges_count || solved_challenges.count) >= times
  end

  def category_list
    categories.map(&:name).join(', ')
  end

  def get_solved_challenge_for(team)
    solved_challenges.find_by(team: team)
  end

  def can_be_solved_by(team)
    get_solved_challenge_for(team).nil?
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

  private

  def state_transition(from, to)
    state_was == from && state == to
  end

  def post_state_change_message
    return unless state_transition('force_closed', 'open') || state_transition('open', 'force_closed')

    Message.create!(
      game: game,
      title: "#{name}: #{category_list} #{point_value}",
      text: I18n.t('challenges.state_change_message', state: state.titleize)
    )
  end
end
