# frozen_string_literal: true

# User model, uses devise to manage registrations. Each user has a team reference which is
# set to nil until they are added to a team.
class User < ApplicationRecord
  include VpnModule
  include ActionView::Helpers::UserHelper

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

  mount_uploader :resume, ResumeUploader
  mount_uploader :transcript, TranscriptUploader

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

  def self.user_editable_keys
    # First line required fields, second line optional
    # Really just broken out into 2 lines to appease rubocop
    %i[
      full_name affiliation year_in_school state
      compete_for_prizes interested_in_employment gender age area_of_study resume transcript
    ]
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
    update(messages_stamp: Time.now.utc)
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

  # For Rails Admin Select
  def gender_enum
    %w[Male Female]
  end

  def state_enum
    us_states
  end

  def year_in_school_enum
    years_in_school
  end

  # generate cert for specific user
  def generate_certificate(rank)
    return nil unless on_a_team?

    output = Tempfile.new("#{id}_completion_certificate")
    rank ||= team.find_rank
    generate_certificate_helper(output, rank)

    output
  end

  private

  def generate_certificate_helper(output, rank)
    dimensions = [720, 540]
    CertModule::CompletionPdf.generate(output, page_size: dimensions) do |doc|
      doc.image doc.instance_variable_get(:@background), at: [0, dimensions[1]], fit: dimensions
      doc.bounding_box([55, 450], width: 640, height: 200) do
        Game.instance.generate_certificate_header doc
      end
      team.generate_certificate_body doc, full_name, rank
    end
  end

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
