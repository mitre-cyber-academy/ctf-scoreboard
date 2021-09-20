# frozen_string_literal: true

# User model, uses devise to manage registrations. Each user has a team reference which is
# set to nil until they are added to a team.
class User < ApplicationRecord
  has_paper_trail only: %i[
    email
    team_id
    full_name
    affiliation
    year_in_school
    state
    compete_for_prizes
    admin
    current_sign_in_ip
  ]

  belongs_to :team, optional: true
  has_many :feed_items, dependent: :destroy
  has_many :user_invites, dependent: :destroy
  has_many :user_requests, dependent: :destroy
  has_many :submitted_flags, dependent: :destroy

  scope :interested_in_employment, -> { where(interested_in_employment: true) }

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :confirmable, :secure_validatable

  # These are things we require user to have but do not require of admins.
  with_options unless: :admin? do
    after_create :link_to_invitations, :update_team
    after_update :update_team
    before_destroy :leave_team_before_delete, prepend: true
    before_save :clear_compete_for_prizes
    validates :email, uniqueness: true, presence: true
    validates :full_name, :affiliation, presence: true, length: { maximum: 255 }, obscenity: true
    validates :state, presence: true, if: -> { country.eql? 'US' }
    validates :year_in_school, inclusion: { in: [0, 9, 10, 11, 12, 13, 14, 15, 16] }, presence: true
    validates :age_requirement_accepted, presence: true
  end

  before_validation -> { self.state = nil }, unless: -> { country.eql? 'US' }

  before_create :skip_confirmation!, unless: -> { Settings.local_login.email_confirmation }

  def self.user_editable_keys
    # First line required fields, second line optional
    # Really just broken out into 2 lines to appease rubocop
    %i[
      full_name affiliation year_in_school state country age_requirement_accepted
      compete_for_prizes interested_in_employment gender age area_of_study
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

  def update_messages_stamp
    update(messages_stamp: Time.now.utc)
  end

  def update_team
    team&.refresh_team_info
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
      generate_certificate_body doc, rank
    end
  end

  def generate_certificate_body(doc, rank)
    doc.bounding_box([55, 200], width: 640, height: 200) do
      doc.font('Helvetica-Bold', size: 18) do
        doc.text(I18n.t('users.team_completion_cert_string',
                        full_name: full_name, team_name: team.team_name,
                        score: team.score, rank: rank, team_size: team.division.teams.size),
                 color: '005BA1', align: :center, leading: 4)
      end
    end
  end

  # If a user chooses to compete for prizes then they must be located in the US and be in school.
  # When a user is not in school the frontend sets the value to 0 and when they are located out
  # of the USA the state is set to NA.
  def clear_compete_for_prizes
    return if country.eql?('US') && !year_in_school.eql?(0)

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
    team&.cleanup
  end
end
