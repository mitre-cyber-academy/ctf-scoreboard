# frozen_string_literal: true

class Challenge < ApplicationRecord
  include StiPreload

  before_save :post_state_change_message

  belongs_to :game

  has_many :challenge_categories, dependent: :destroy
  has_many :categories, through: :challenge_categories

  has_many :submitted_flags, dependent: :destroy

  enum state: { closed: 0, open: 1, force_closed: 2 }

  validates :name, :point_value, presence: true

  # Handles the ordering of all returned challenge objects.
  default_scope -> { order(:point_value, :name) }

  scope :non_pentest, -> { where.not(type: 'PentestChallenge') }

  attr_accessor :submitted_flag, :solved_challenges_count

  def self.type_enum
    [['PentestChallenge'], ['ShareChallenge'], ['StandardChallenge']]
  end

  validates :type, inclusion: type_enum.flatten, presence: true

  # This bypasses game open check and only looks at the challenge state
  def challenge_open?
    state.eql? 'open'
  end

  def before_close?
    return Time.now.utc < close_challenge_at unless close_challenge_at.nil?

    true
  end

  def after_open?
    return Time.now.utc > open_challenge_at unless open_challenge_at.nil?

    true
  end

  def open?
    challenge_open? && before_close? && after_open? && game.open?
  end

  def display_point_value(_ = nil)
    # Some subclasses override the point_value method with a custom
    # point value calculation, requiring a teams parameter. We don't
    # need it here so we just throw it away
    point_value
  end

  def solved?(times = 1)
    # We sometimes define solved_challenges_count using the
    # activerecord preloader gem. If we have done this then
    # we should utilize that count, if not then we should fall
    # through and use the regular old count method.
    (solved_challenges_count || solved_challenges.count) >= times
  end

  def category_list
    return I18n.t('challenges.no_category') if categories.empty?

    categories.map(&:name).join(', ')
  end

  def get_solved_challenge_for(team)
    solved_challenges.find { |sc| sc.team_id.eql?(team&.id) }
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

  # The next challenge can have a greater than or equal to point value of the current one
  # and has a name that comes after the current one. The order in which elements are returned
  # to self.challenges in is set in the challenges model.
  def next_challenge
    # Order of challenges is handled by default scope in challenge.rb
    challenges_in_category = game.categories_with_standard_challenges[category_ids]
    index = challenges_in_category.find_index(self)
    challenges_in_category[index + 1] unless index.nil?
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
