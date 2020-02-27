# frozen_string_literal: true

# This is effectively a has_and_belongs_to_many relation table for linking challenges to categories

class ChallengeCategory < ApplicationRecord
  validate :challenge_and_category_belong_to_same_game
  belongs_to :challenge
  belongs_to :category

  def challenge_and_category_belong_to_same_game
    unless challenge.game == category.game
      errors.add(:challenge, I18n.t('challenge_categories.same_game'))
    end
  end
end
