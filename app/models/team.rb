# frozen_string_literal: true
# Team model for holding the main user list and all invites and requests to a team.
class Team < ActiveRecord::Base
  has_many :users
  has_many :user_invites, dependent: :destroy
  has_many :user_requests, dependent: :destroy
  belongs_to :team_captain, class_name: 'User'
  accepts_nested_attributes_for :user_invites
  validates :team_name, :affiliation, presence: true, obscenity: true
  validates :team_name, uniqueness: { case_sensitive: false }

  after_save :set_team_captain

  filterrific(
    available_filters: [
      :filter_team_name,
      :filter_affiliation,
      :location,
      :hs_college
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
  scope :hs_college, lambda { |query|
    appropriate_teams = select { |team| team if team.division_level.eql? query }
    appropriate_teams.collect!(&:id)
    where(id: appropriate_teams)
  }

  # Returns whether everyone on the team is currently eligible for prize money.
  def eligible_for_prizes?
    eligible = true
    users.each do |user|
      eligible = false unless user.compete_for_prizes
    end
    eligible
  end

  # A team can only consist of 5 users.
  def slots_available
    5 - users.count
  end

  def division_level
    return 'Unknown' if users.empty?
    return 'Professional' if users.minimum('year_in_school').eql? 0
    return 'High School' if users.maximum('year_in_school') <= 12
    'College' # If user is not in any of the other three then fallback.
  end

  # If no slots are available then mark the team as full.
  def full?
    slots_available.eql? 0
  end

  def self.options_for_school_level
    [
      ['High School', 'High School'],
      %w(College College),
      %w(Professional Professional)
    ]
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
    update_attribute(:team_captain, users.find_by_id(user_id))
  end

  # Uses the teams team_name but removes extra characters in order to make it easier
  # for the team to login.
  def scoreboard_login_name
    team_name.downcase.tr(' @$', '_as').gsub(/[^a-z0-9_]/, '')
  end

  # Group user states and then get the largest one.
  def common_team_location
    users.map(&:state).group_by(&:itself).values.max_by(&:size).first
  end

  private

  # If a team doesn't have a team captain but does have a user, set the team captain to the first user.
  def set_team_captain
    return unless team_captain.nil? && !users.empty?
    update_attribute(:team_captain, users.first)
  end
end
