# frozen_string_literal: true

class PointChallenge < Challenge
  before_save :post_state_change_message

  belongs_to :category, optional: false

  has_many :flags, inverse_of: :challenge, foreign_key: 'challenge_id', class_name: 'ChallengeFlag', dependent: :destroy

  has_many :solved_challenges, inverse_of: :challenge, foreign_key: 'challenge_id', class_name: 'PointSolvedChallenge',
                               dependent: :destroy

  accepts_nested_attributes_for :flags, allow_destroy: true

  def post_state_change_message
    return unless state_transition('force_closed', 'open') || state_transition('open', 'force_closed')

    Message.create!(
      game: Game.instance,
      title: "#{name}: #{category.name} #{point_value}",
      text: I18n.t('challenges.state_change_message', state: state.titleize)
    )
  end
end
