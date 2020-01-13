# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :divisions, dependent: :destroy
  has_many :teams, through: :divisions, dependent: :destroy
  has_many :users, through: :teams, dependent: :destroy
  has_many :feed_items, through: :divisions, dependent: :destroy
  has_many :achievements, through: :divisions, dependent: :destroy
  has_many :solved_challenges, through: :divisions, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :challenges, through: :categories, dependent: :destroy

  validates :title, :start, :stop, :do_not_reply_email, :contact_email, :description, presence: true

  validate :instance_is_singleton, :order_of_start_and_stop_date

  mount_uploader :completion_certificate_template, CompletionCertificateTemplateUploader

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
    Time.now.utc < start
  end

  def after_competition?
    Time.now.utc > stop
  end

  def remind_all
    User.all.find_each do |usr|
      UserMailer.competition_reminder(usr).deliver_later
    end
  end

  # generates the top of the certificate when given a Prawn Document
  def generate_certificate_header(doc)
    doc.font('Helvetica', size: 28, style: :bold) do
      doc.text title.to_s, color: '005BA1', size: 28, align: :center, leading: 8
      doc.text "#{start.day}-#{stop.day} #{I18n.t('date.month_names')[start.month]} #{start.year}",
               color: '005BA1', align: :center, size: 20
    end
  end

  # Fetch every teams name and current score to provide JSON feed of team rankings
  def all_teams_information
    results = divisions.collect(&:ordered_teams_with_rank).flatten
    results.collect { |team| { pos: team.rank, team: team.team_name, score: team.current_score } }
  end

  def open_source
    User.all.find_each do |usr|
      UserMailer.open_source(usr).deliver_later
    end
  end

  # reload user_count counter_cache in team
  def reload_user_count
    teams.each do |team|
      Team.reset_counters team.id, :users
    end
  end
end
