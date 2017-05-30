# frozen_string_literal: true

# Team model for holding the main user list and all invites and requests to a team.
class Team < ActiveRecord::Base
  has_paper_trail

  has_many :feed_items
  has_many :achievements
  has_many :solved_challenges
  has_many :users
  has_many :user_invites, dependent: :destroy
  has_many :user_requests, dependent: :destroy
  has_many :submitted_flags, through: :users
  belongs_to :division, required: true
  belongs_to :team_captain, class_name: 'User'
  accepts_nested_attributes_for :user_invites
  validates :team_name, :affiliation, presence: true, obscenity: true
  validates :team_name, uniqueness: { case_sensitive: false }

  after_save :set_team_captain, :update_eligibility

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
    search_by(query, 'affiliation')
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

  # A team can only consist of 5 users.
  def slots_available
    5 - users.count
  end

  def in_top_ten?
    !solved_challenges.empty? && (division.ordered_teams[0..9].include? self)
  end

  def appropriate_division_level?
    # Make sure all the users years in school fall within the acceptable years in school
    # for the division.
    (users.collect(&:year_in_school) - division.acceptable_years_in_school).empty?
  end

  def team_competing_for_prizes?
    users.collect(&:compete_for_prizes).uniq.eql? [true]
  end

  # If no slots are available then mark the team as full.
  def full?
    slots_available.eql? 0
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
    update_attributes(team_captain: users.find_by(id: user_id))
  end

  def update_eligibility
    reload # SQL caching causing users to be empty when creating team making all teams ineligible
    new_eligibility = team_competing_for_prizes? && appropriate_division_level?
    # Check if eligibility is different from what is saved on the team object and
    # if it is update the team model.
    update_attributes(eligible: new_eligibility) unless new_eligibility.eql? eligible?
  end

  def score
    feed_items.where(type: [SolvedChallenge, ScoreAdjustment])
              .joins(
                'LEFT JOIN challenges ON challenges.id = feed_items.challenge_id'
              )
              .pluck(:point_value, :'challenges.point_value').flatten.compact.sum
  end

  def display_name
    return self[:team_name] if eligible?
    self[:team_name] + ' (ineligible)'
  end

  private

  # If a team doesn't have a team captain but does have a user, set the team captain to the first user.
  def set_team_captain
    update_attributes(team_captain: users.first) if team_captain.nil? && !users.empty?
  end
end
