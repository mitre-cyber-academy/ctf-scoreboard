# frozen_string_literal: true

# Team model for holding the main user list and all invites and requests to a team.
class Team < ApplicationRecord
  has_paper_trail ignore: %i[created_at updated_at]

  # Rank is an attribute that can be added to the team model on the fly however
  # it has no value by default. This allows us to cache a teams current rank
  # without having to hit the database to calculate it.
  attr_accessor :rank

  has_many :feed_items, dependent: :destroy
  has_many :achievements, dependent: :destroy
  has_many :solved_challenges, dependent: :destroy
  has_many :users, after_remove: :update_captain_and_eligibility, dependent: :nullify
  has_many :user_invites, dependent: :destroy
  has_many :user_requests, dependent: :destroy
  has_many :submitted_flags, through: :users, dependent: :destroy
  belongs_to :division, required: true
  # team_captain has no inverse
  # rubocop:disable Rails/InverseOf
  belongs_to :team_captain, class_name: 'User'
  # rubocop:enable Rails/InverseOf
  accepts_nested_attributes_for :user_invites
  validates :team_name, :affiliation, presence: true, obscenity: true
  validates :team_name, uniqueness: { case_sensitive: false }

  after_save :update_captain_and_eligibility

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

  # A team can only consist of 5 users.
  def slots_available
    5 - users.size
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

  # If no slots are available then mark the team as full.  Makes new query to make sure result is accurate
  def full?
    users.count.eql? 5
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
    update_attributes(team_captain: new_captain) if new_captain
    !new_captain.nil?
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

  # After remove callback passes a parameter which is the object that was just removed, we don't need it
  # so we just throw it away
  def update_captain_and_eligibility(*)
    set_team_captain
    update_eligibility
  end

  # iterate over all users to create completion certs and maybe send ranking email
  def generate_completion_certificates(rank, total, send_email)
    @template_file = Rails.root.join 'templates', 'ctf-certificate-template.jpg'
    team_cert_directory = make_completion_cert_directories
    users.each do |user|
      path = generate_certificate(user, team_cert_directory, rank, total)
      UserMailer.ranking(user, rank, path.to_s).deliver_later if send_email
    end
  end

  # generate cert for specific user
  def generate_certificate(user, directory, rank, total)
    dimensions = [720, 540]
    file_name = directory.join user.id.to_s + '.pdf'
    CertModule::CompletionPdf.generate(file_name, background: @template_file, page_size: dimensions, margin: 0) do |doc|
      doc.image @template_file, at: [0, dimensions[1]], fit: dimensions
      doc.bounding_box([55, 450], width: 640, height: 200) do
        Game.instance.generate_certificate_header doc
      end
      generate_certificate_body doc, user.full_name, rank, total
    end
    file_name
  end

  # generates the body of the certificate
  def generate_certificate_body(doc, username, rank, total)
    doc.bounding_box([55, 200], width: 640, height: 200) do
      doc.font('Helvetica-Bold', size: 18) do
        doc.text team_completion_cert_string(username, rank, total), color: '005BA1', align: :center, leading: 4
      end
    end
  end

  def team_completion_cert_string(username, rank, total)
    "This is to certify that #{username}
     successfully competed as a member of Team #{team_name},
     achieving #{score} points and finishing #{rank} out of #{total} teams."
  end

  # creates division and team directories unless they already exist
  def make_completion_cert_directories
    make_team_directory make_division_directory
  end

  # creates division directory for storing completion certificates if it does not exist
  def make_division_directory
    certs_directory = Rails.root.join 'tmp', self.class.transform(division.name) + '-certificates'
    FileUtils.mkdir_p(certs_directory) unless Dir.exist?(certs_directory)
    certs_directory
  end

  # creates team directory for storing completion certificates if it does not exist
  def make_team_directory(certs_directory)
    team_cert_directory = certs_directory.join id.to_s
    FileUtils.mkdir_p(team_cert_directory) unless Dir.exist?(team_cert_directory)
    team_cert_directory
  end

  private

  # If a team doesn't have a team captain but does have a user, set the team captain to the first user.
  def set_team_captain
    update_attributes(team_captain: users.first) if team_captain.nil? && !users.empty?
  end
end
