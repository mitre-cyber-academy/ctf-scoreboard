# frozen_string_literal: true

class Game < ApplicationRecord
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
    time = Time.now.utc
    (start < time && time < stop)
  end

  def before_competition?
    time = Time.now.utc
    time < start
  end

  def remind_all
    User.all.find_each do |usr|
      UserMailer.competition_reminder(usr).deliver_now
    end
  end

  def send_rankings
    CertificateGenerator.new.generate_all_certs
    teams.each_with_index do |team, index|
      team.users.each do |usr|
        UserMailer.ranking(usr, index + 1).deliver_now
      end
    end
  end
end
