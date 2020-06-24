# frozen_string_literal: true

class Game < ApplicationRecord
  validates :title, :start, :stop, :contact_email, :description, presence: true

  validate :instance_is_singleton, :order_of_start_and_stop_date

  mount_uploader :completion_certificate_template, CompletionCertificateTemplateUploader

  validates :completion_certificate_template, presence: true, if: :enable_completion_certificates?

  with_options dependent: :destroy do
    has_many :messages
    has_many :categories, dependent: :destroy
    has_many :pentest_challenges, dependent: :destroy
    has_many :defense_flags, through: :pentest_challenges
    has_many :standard_challenges, dependent: :destroy
    has_many :challenges, inverse_of: :game, foreign_key: 'game_id'
    has_many :divisions, dependent: :destroy
    has_many :teams, through: :divisions
    has_many :users, through: :teams
    has_many :feed_items, through: :divisions
    has_many :achievements, through: :divisions
    has_many :standard_solved_challenges, through: :divisions
    has_many :pentest_solved_challenges, through: :divisions
    has_many :solved_challenges, through: :divisions
  end

  enum board_layout: { jeopardy: 0, teams_x_challenges: 1, multiple_categories: 2, title_and_description: 3 }

  after_commit { Rails.cache.delete('game_instance') }

  def self.instance
    Rails.cache.fetch('game_instance') { all.first }
  end

  def instance_is_singleton
    singleton = Game.all.first
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

  # As the game progresses, this returns a reasonable grouping for the different graphs in the application.
  # One such graph is on the Team Summary page and the other is the Game Summary
  def graph_group_method
    ((defense_end - start) / 1.day).days < 1.week ? :hour : :day
  end

  def categories_with_standard_challenges
    standard_challenges&.group_by(&:category_ids)&.sort_by { |categories, _| -categories.length }&.to_h
  end

  # This method returns either the current time in UTC or end of the game if the game is over.
  # The end of the defense time is either the end of the game or current time if we are during the game.
  # This is used to show the defensive points in a more sliding manner, instead of just showing
  # all of the potential points a team can earn for defense, it only shows up to the current time.
  def defense_end
    open? ? Time.now.utc : stop
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

  def max_category_size
    categories_with_standard_challenges.values.map(&:length).max || 0
  end

  def teams_associated_with_flags_and_pentest_challenges
    teams.map do |team|
      team_challenge_flags = pentest_challenges.map do |challenge|
        matched_flag = defense_flags.to_a.find do |flag|
          flag.team_id.eql?(team.id) && flag.challenge_id.eql?(challenge.id)
        end
        { flag: matched_flag, challenge: challenge }
      end
      [team, team_challenge_flags]
    end
  end
end
