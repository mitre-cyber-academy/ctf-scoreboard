# frozen_string_literal: true

# User model, uses devise to manage registrations. Each user has a team reference which is
# set to nil until they are added to a team.
class User < ActiveRecord::Base
  belongs_to :team
  has_many :feed_items
  has_many :user_invites
  has_many :user_requests
  enum gender: %i[Male Female]

  geocoded_by :current_sign_in_ip
  after_validation :geocode, unless: :geocoded?

  reverse_geocoded_by :latitude, :longitude do |obj, results|
    if (geo = results.first)
      obj.country = geo.country_code
    end
  end
  after_validation :reverse_geocode, if: ->(obj) { obj.latitude_changed? || obj.longitude_changed? }

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :confirmable, :secure_validatable

  # These are things we require user to have but do not require of admins.
  with_options unless: :admin? do |user|
    user.before_save :clear_compete_for_prizes
    user.after_create :link_to_invitations
    user.validates :full_name, :affiliation, presence: true, obscenity: true
    user.validates :state, presence: true
    user.validates :age, numericality: { greater_than_or_equal_to: 0, less_than: 200 }, allow_blank: true
    user.validates :year_in_school, inclusion: { in: [0, 9, 10, 11, 12, 13, 14, 15, 16] }, presence: true
    user.validates :gender, inclusion: { in: genders.keys }, allow_blank: true
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

  def key_file_name
    email.tr('^A-Za-z', '')[0..10] + id.to_s
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
end
