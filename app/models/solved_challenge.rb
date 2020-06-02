# frozen_string_literal: true

class SolvedChallenge < FeedItem
  scope :ordered, -> { order('created_at ASC') }

  validate :team_can_solve_challenge, :challenge_is_open, :game_is_open

  after_save :award_achievement

  after_save :open_next_challenge

  belongs_to :team, optional: false, inverse_of: :solved_challenges
  belongs_to :division, optional: false

  def challenge_is_open
    errors.add(:challenge, I18n.t('challenges.not_open')) unless challenge.open?
  end

  def game_is_open
    errors.add(:base, I18n.t('challenges.game_not_open')) unless challenge.game.open?
  end

  def award_achievement
    # if this is the first solved challenge
    Achievement.create(team: team, text: 'First Blood!') if challenge.game.solved_challenges.size == 1
    name = challenge.achievement_name
    Achievement.create(team: team, text: name) if name.present?
  end

  def open_next_challenge
    next_challenge = challenge.next_challenge
    next_challenge.state!('open') if next_challenge&.available?
  end

  def team_can_solve_challenge
    errors.add(:base, I18n.t('challenges.already_solved'))
  end
end
