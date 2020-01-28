# frozen_string_literal: true

# Team model for holding the main user list and all invites and requests to a team.
class Team < ApplicationRecord
  has_paper_trail ignore: %i[created_at updated_at]

  # Rank is an attribute that can be added to the team model on the fly however
  # it has no value by default. This allows us to cache a teams current rank
  # without having to hit the database to calculate it.#
  #
  # Current_score is so we don't have to have any logic to handle
  # which class we are rendering in the game summary view.
  attr_accessor :rank, :current_score

  # This has_many is only applicable to PentestGames
  has_many :flags, class_name: 'PentestFlag'
  has_many :feed_items, dependent: :destroy
  has_many :achievements, dependent: :destroy
  has_many :solved_challenges, inverse_of: :team, dependent: :destroy
  has_many :users, dependent: :nullify
  has_many :user_invites, dependent: :destroy
  has_many :user_requests, dependent: :destroy
  has_many :submitted_flags, through: :users, dependent: :destroy
  belongs_to :division, optional: false
  # team_captain has no inverse
  belongs_to :team_captain, class_name: 'User'
  accepts_nested_attributes_for :user_invites
  validates :team_name, :affiliation, presence: true, length: { maximum: 255 }, obscenity: true
  validates :team_name, uniqueness: { case_sensitive: false }

  after_save :refresh_team_info

  filterrific(
    available_filters: %i[
      filter_team_name
      filter_affiliation
      location
      division
    ]
  )

  scope :filter_team_name, lambda { |query|
    return nil if query.blank?

    search_by(query, 'team_name')
  }

  scope :filter_affiliation, lambda { |query|
    return nil if query.blank?

    search_by(query, 'teams.affiliation')
  }

  scope :location, lambda { |query|
    joins(:users).where(users: { state: query })
  }

  # This has a few more queries than needed in order to keep the function somewhat simple.
  # It honestly doesn't belong in a scope but has to be in order to work with filterrific.
  # We select all of the teams where the division level of the team equals the level currently
  # passed in. The problem is filterrific expects an activerecord relation. In order to satisfy
  # this we get just the id's from the teams and then query for just those teams which returns
  # an activerecord relation.
  scope :division, lambda { |query|
    appropriate_teams = select { |team| team if team.division_id.eql? query }.collect!(&:id)
    where(id: appropriate_teams)
  }

  def in_top_ten?
    !solved_challenges.size.zero? && (division.ordered_teams[0..9].include? self)
  end

  def appropriate_division_level?
    # Make sure all the users years in school fall within the acceptable years in school
    # for the division.
    (users.collect(&:year_in_school) - division.acceptable_years_in_school).empty?
  end

  # If no slots are available then mark the team as full.
  def full?
    slots_available.zero?
  end

  def find_rank
    (1 + (division.ordered_teams.index self))
  end

  # rubocop:disable Metrics/AbcSize
  # Takes a query and the column it is filtering and returns results.
  def self.search_by(query, column_to_filter)
    # condition query, parse into individual keywords
    terms = query.to_s.downcase.split(/\s+/)
    # replace "*" with "%" for wildcard searches,
    # prepend and append '%', remove duplicate '%'s
    terms = terms.map { |e| ('%' + e.tr('*', '%') + '%').gsub(/%+/, '%') }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conditions = 1
    where(
      terms.map do
        or_clauses = ["LOWER(#{column_to_filter}) LIKE ?"].join(' OR ')
        "(#{or_clauses})"
      end.join(' AND '),
      *terms.map { |e| [e] * num_or_conditions }.flatten
    )
  end
  # rubocop:enable Metrics/AbcSize

  def cleanup
    destroy if users.empty?
  end

  def promote(user_id)
    new_captain = users.find_by(id: user_id)
    update(team_captain: new_captain) if new_captain
  end

  def score
    division.ordered_teams.detect { |team| team.id = id }.current_score
  end

  # After remove callback passes a parameter which is the object that was just removed, we don't need it
  # so we just throw it away
  def refresh_team_info(*)
    reload # SQL caching causing users to be empty when creating team making all teams ineligible
    set_team_captain
    set_slots_available
    set_eligibility
    cleanup
  end

  def calc_defensive_points
    flags.map do |flag|
      [flag.name, flag.calc_defensive_points.round]
    end.to_h
  end

  private

  # If a team doesn't have a team captain but does have a user, set the team captain to the first user.
  def set_team_captain
    if users.empty?
      users << team_captain unless team_captain.nil?
    elsif team_captain.nil?
      update(team_captain: users.first)
    end
  end

  # Number of users on team is calculated using game team size
  def set_slots_available
    updated_slots_available = division.game.team_size - users.count
    update(slots_available: updated_slots_available) unless updated_slots_available.eql? slots_available
  end

  def set_eligibility
    new_eligibility = competing_for_prizes? && appropriate_division_level?
    # Check if eligibility is different from what is saved on the team object and
    # if it is update the team model.
    update(eligible: new_eligibility) unless new_eligibility.eql? eligible?
  end

  def competing_for_prizes?
    users.collect(&:compete_for_prizes).uniq.eql? [true]
  end
end
