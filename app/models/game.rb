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

  def generate_completion_certs(send_email = true) # hit all divisions and iterate over all teams to create certs
    divisions.each do |div|
      size = div.teams.size
      div.ordered_teams.each_with_index do |team, index|
        team.generate_completion_certificates index + 1, size, send_email unless team.users.size.zero?
      end
    end
  end

  def generate_certificate_header(doc) # generates the top of the certificate when given a Prawn Document
    doc.font('Helvetica', size: 28, style: :bold) do
      doc.text name.to_s, color: '005BA1', align: :center, leading: 8
      doc.text "#{start.day}-#{stop.day} #{I18n.t('date.month_names')[start.month]} #{start.year}",
               color: '005BA1', align: :center
    end
  end

  def reload_user_count # reload user_count counter_cache in team
    teams.each do |team|
      Team.reset_counters team.id, :users
    end
  end
end
