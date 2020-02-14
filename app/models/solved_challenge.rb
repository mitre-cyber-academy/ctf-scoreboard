# frozen_string_literal: true

class SolvedChallenge < FeedItem
  scope :ordered, -> { order('created_at ASC') }

  validate :team_can_solve_challenge, :challenge_is_open, :game_is_open

  after_save :award_achievement

  after_save :open_next_challenge, unless: -> { Game.instance.is_a?(PentestGame) }

  belongs_to :team, optional: false, inverse_of: :solved_challenges

  def description
    %(#{super.titleize} "#{challenge.category.name} #{challenge.point_value}")
  end

  def icon
    super('ok')
  end

  def challenge_is_open
    errors.add(:challenge, I18n.t('challenges.not_open')) unless challenge.open?
  end

  def game_is_open
    errors.add(:base, I18n.t('challenges.game_not_open')) unless Game.instance.open?
  end

  def award_achievement
    # if this is the first solved challenge
    Achievement.create(team: team, text: 'First Blood!') if Game.instance.solved_challenges.all.count == 1
    name = challenge.achievement_name
    Achievement.create(team: team, text: name) if name.present?
  end

  def open_next_challenge
    challenge = self.challenge
    category = challenge.category
    challenge = category.next_challenge(challenge)
    challenge.state!('open') if challenge&.available?
  end

  def team_can_solve_challenge
    errors.add(:base, I18n.t('challenges.already_solved'))
  end
end
