# frozen_string_literal: true

class DefenseFlag < Flag
  include FlagChallengeShareModule

  validates :challenge, uniqueness: { scope: :team_id, message: I18n.t('flag.challenge_must_be_unique') }

  belongs_to :team, inverse_of: :defense_flags, optional: false
  belongs_to :challenge, inverse_of: :defense_flags, class_name: 'PentestChallenge'

  has_many :solved_challenges, -> { ordered }, inverse_of: :flag, foreign_key: 'flag_id',
                                               class_name: 'PentestSolvedChallenge', dependent: :destroy

  has_many :submitted_flags, inverse_of: :flag, foreign_key: 'flag_id', class_name: 'PentestSubmittedFlag',
                             dependent: :destroy

  attr_accessor :submitted_flag

  enum challenge_state: { inherit_parent_state: 0, force_closed: 1 }

  def get_solved_challenge_for(team)
    challenge.get_solved_challenge_for(team, self)
  end

  # Without allow_nil rails_admin cannot load defense_flag new page
  delegate :name, :description, :first_capture_point_bonus, :calc_point_value, :calc_shares,
           :calc_defensive_points_helper, to: :challenge, allow_nil: true

  def force_closed?
    super || challenge.force_closed?
  end

  def challenge_open?
    !force_closed? && challenge.challenge_open?
  end

  def start_calculation_at
    super || Game.instance.start
  end

  def open?
    !force_closed? && challenge.open?
  end

  def sponsored
    challenge.sponsored
  end

  def sponsor_logo
    challenge.sponsor_logo
  end

  def sponsor_description
    challenge.sponsor_description
  end

  def find_flag(flag_str)
    return self if flag_str == flag
  end

  def can_be_solved_by(team)
    challenge.can_be_solved_by(team, self)
  end
end
