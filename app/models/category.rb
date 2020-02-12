# frozen_string_literal: true

class Category < ApplicationRecord
  belongs_to :game, optional: false
  has_many :challenges, foreign_key: 'category_id', class_name: 'PointChallenge', dependent: :destroy,
                        inverse_of: :category

  validates :name, presence: true

  # The next challenge can have a greater than or equal to point value of the current one
  # and has a name that comes after the current one. The order in which elements are returned
  # to self.challenges in is set in the challenges model.
  def next_challenge(challenge)
    # Order of challenges is handled by default scope in challenge.rb
    index = challenges.find_index(challenge)
    challenges[index + 1] unless index.nil?
  end
end
