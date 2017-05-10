# frozen_string_literal: true

class SolvedChallenge < FeedItem
  validate :team_has_not_solved_challenge, :challenge_is_open, :game_is_open

  after_save :award_achievement, :open_next_challenge

  belongs_to :flag
  belongs_to :division
  belongs_to :team

  def description
    %(Solved challenge "#{challenge.category.name} #{challenge.point_value}")
  end

  def icon
    'ok'
  end

  def challenge_is_open
    errors.add(:challenge, I18n.t('challenge.not_open')) unless challenge.open?
  end

  def game_is_open
    errors.add(:base, I18n.t('challenge.game_not_open')) unless challenge.category.game.open?
  end

  def team_has_not_solved_challenge
    challenge_is_solved = team.solved_challenges.where('challenge_id = ?', challenge.id).count.positive?
    errors.add(:base, I18n.t('challenge.already_solved')) if challenge_is_solved
  end

  def award_achievement
    if Game.instance.solved_challenges.all.count == 1 # if this is the first solved challenge
      Achievement.create(team: team, text: 'First Blood!')
    end
    name = challenge.achievement_name
    Achievement.create(team: team, text: name) if name.present?
  end

  def open_next_challenge
    challenge = self.challenge
    category = challenge.category
    challenge = category.next_challenge(challenge)
    challenge.set_state(player.division, 'open') if challenge && challenge.available?(player.division)
  end
end
