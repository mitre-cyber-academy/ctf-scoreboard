# frozen_string_literal: true

# User model, uses devise to manage registrations. Each user has a team reference which is
# set to nil until they are added to a team.
class User < ApplicationRecord
  include VpnModule

  has_paper_trail only: %i[
    email
    team_id
    full_name
    affiliation
    year_in_school
    age
    state
    compete_for_prizes
    admin
  ]

  belongs_to :team, counter_cache: true
  has_many :feed_items, dependent: :destroy
  has_many :user_invites, dependent: :destroy
  has_many :user_requests, dependent: :destroy
  has_many :submitted_flags, dependent: :destroy

  geocoded_by :current_sign_in_ip
  after_validation :geocode, unless: :geocoded?

  after_create :create_vpn_cert_request

  reverse_geocoded_by :latitude, :longitude do |obj, results|
    if (geo = results.first)
      obj.country = geo.country
    end
  end
  after_validation :reverse_geocode, if: ->(obj) { obj.latitude_changed? || obj.longitude_changed? }

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :confirmable, :secure_validatable

  # These are things we require user to have but do not require of admins.
  with_options unless: :admin? do
    before_save :clear_compete_for_prizes
    before_destroy :leave_team_before_delete
    after_create :link_to_invitations
    after_update :update_team
    validates :email, uniqueness: true
    validates :full_name, :affiliation, presence: true, obscenity: true
    validates :state, presence: true
    validates :age, numericality: { greater_than_or_equal_to: 0, less_than: 200 }, allow_blank: true
    validates :year_in_school, inclusion: { in: [0, 9, 10, 11, 12, 13, 14, 15, 16] }, presence: true
    validates :gender, inclusion: { in: %w[Male Female] }, allow_blank: true
  end

  # Returns whether a user is currently on a team or not.
  def on_a_team?
    !team.nil?
  end

  def team_captain?
    if on_a_team?
      team.team_captain.eql? self
    else
      false
    end
  end

  def division
    return 'College' if year_in_school >= 13
    return 'Professional' if year_in_school.eql? 0
    return 'High School' if year_in_school <= 12
    'Unknown' # If user is not in any of the other three then fallback.
  end

  # A user can only promote another user if they are the team captain. The user that they
  # promote cannot be themselves.
  def can_promote?(user)
    (!eql? user) && (team.team_captain.eql? self)
  end

  # A user can only remove someone from a team if they are the team captain
  def can_remove?(user)
    (eql? user) || (team.team_captain.eql? self)
  end

  def vpn_cert_file_name
    id.to_s
  end

  def update_messages_stamp
    update_attributes(messages_stamp: Time.now.utc)
  end

  def create_vpn_cert_request
    S3Certificates.instance.create_certificate_for(vpn_cert_file_name)
  end

  # Returns nil if the user does not currently have a certificate generated for them
  # Returns a URL that is valid for 10 minutes for the user to download their vpn
  # certificate file if their certificate is already generated
  def vpn_cert_url
    S3Certificates.instance.find_or_create_cert_for(vpn_cert_file_name)
  end

  def vpn_cert_request_created?
    S3Certificates.instance.bucket_file_exists?(vpn_cert_file_name)
  end

  def vpn_cert_available?
    S3Certificates.instance.cert_ready_for?(vpn_cert_file_name)
  end

  def update_team
    team&.update_captain_and_eligibility
  end

  private

  # If a user chooses to compete for prizes then they must be located in the US and be in school.
  # When a user is not in school the frontend sets the value to 0 and when they are located out
  # of the USA the state is set to NA.
  def clear_compete_for_prizes
    return unless year_in_school.eql?(0) || state.eql?('NA')
    self.compete_for_prizes = false
    nil # http://apidock.com/rails/ActiveRecord/RecordNotSaved
  end

  # When a new user is created, check to see if the users email has been invited to any teams.
  def link_to_invitations
    UserInvite.where(email: email).find_each do |invite|
      invite.user = self
      invite.save
    end
  end

  # This should only be used when an account is being deleted, it allows the team to update internal information
  def leave_team_before_delete
    team&.users&.delete(self)
  end
end
