# frozen_string_literal: true

class Challenge < ApplicationRecord
  before_save :post_state_change_message

  belongs_to :category, required: true
  has_many :flags, inverse_of: :challenge, dependent: :destroy
  has_many :solved_challenges, dependent: :destroy
  has_many :submitted_flags, dependent: :destroy

  enum state: { closed: 0, open: 1, force_closed: 2 }

  validates :name, :point_value, :flags, presence: true

  accepts_nested_attributes_for :flags, allow_destroy: true

  # Handles the ordering of all returned challenge objects.
  default_scope -> { order(:point_value, :name) }

  attr_accessor :submitted_flag, :solved_challenges_count

  # This bypasses game open check and only looks at the challenge state
  def challenge_open?
    state.eql? 'open'
  end

  def open?
    challenge_open? && category.game.open?
  end

  def solved?
    # We sometimes define solved_challenges_count using the
    # activerecord preloader gem. If we have done this then
    # we should utilize that count, if not then we should fall
    # through and use the regular old count method.
    (solved_challenges_count || solved_challenges.count).positive?
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

  def post_state_change_message
    return unless state_transition('force_closed', 'open') || state_transition('open', 'force_closed')
    Message.create!(
      game: Game.instance,
      title: "#{name}: #{category.name} #{point_value}",
      text: I18n.t('challenge.state_change_message', state: state.titleize)
    )
  end

  def find_flag(flag_str)
    flags.find { |flag_obj| flag_obj.flag.casecmp(flag_str).zero? }
  end

  private

  def state_transition(from, to)
    state_was == from && state == to
  end
end
