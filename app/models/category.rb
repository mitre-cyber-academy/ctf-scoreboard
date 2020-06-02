# frozen_string_literal: true

class Category < ApplicationRecord
  belongs_to :game, optional: false

  has_many :challenge_categories, dependent: :destroy
  has_many :challenges, through: :challenge_categories

  validates :name, presence: true
end
