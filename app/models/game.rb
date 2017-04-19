class Game < ActiveRecord::Base
  has_many :divisions
  has_many :teams, through: :divisions
  has_many :feed_items, through: :divisions
  has_many :achievements, through: :divisions
  has_many :messages
  has_many :categories
  has_many :challenges, through: :categories
end
