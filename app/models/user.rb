# User model, uses devise to manage registrations. Each user has a team reference which is
# set to nil until they are added to a team.
class User < ActiveRecord::Base
  belongs_to :team
  has_many :user_invites
  has_many :user_requests
  before_save :clear_compete_for_prizes
  after_create :link_to_invitations
  enum gender: [:Male, :Female]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :confirmable, :secure_validatable

  validates :full_name, :affiliation, :state, presence: true
  validates :age, numericality: { greater_than_or_equal_to: 0, less_than: 200 }, allow_blank: true
  validates :year_in_school, inclusion: { in: [0, 9, 10, 11, 12, 13, 14, 15, 16] }, presence: true
  validates :gender, inclusion: { in: genders.keys }, allow_blank: true

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
