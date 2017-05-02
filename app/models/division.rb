class Division < ActiveRecord::Base
  belongs_to :game
  has_many :teams, dependent: :destroy
  has_many :feed_items
end