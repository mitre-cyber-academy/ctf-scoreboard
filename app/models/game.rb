# frozen_string_literal: true

class Game < ActiveRecord::Base
  has_many :divisions
  has_many :teams, through: :divisions
  has_many :feed_items, through: :divisions
  has_many :achievements, through: :divisions
  has_many :solved_challenges, through: :divisions
  has_many :messages
  has_many :categories
  has_many :challenges, through: :categories

  validates :name, :start, :stop, presence: true

  validate :instance_is_singleton, :order_of_start_and_stop_date

  def self.instance
    all.first
  end

  def instance_is_singleton
    singleton = Game.instance
    errors.add(:base, I18n.t('game.too_many')) if self != singleton && !singleton.nil?
  end

  def order_of_start_and_stop_date
    errors.add(:base, I18n.t('game.date_mismatch')) unless start < stop
  end

  def open?
    time = Time.zone.now
    (start < time && time < stop)
  end
end
