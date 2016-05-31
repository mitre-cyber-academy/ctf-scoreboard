class User < ActiveRecord::Base
  belongs_to :team
  has_many :user_invites
  has_many :user_requests
  before_save :clear_compete_for_prizes
  after_create :link_to_invitations
  enum gender: [ :Male, :Female ]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, 
         :rememberable, :trackable, :confirmable, :secure_validatable

  validates_presence_of :full_name, :affiliation, :state, presence: true
  validates_inclusion_of :year_in_school, :in => [0, 9, 10, 11, 12, 13, 14, 15, 16], :presence => true
  validates :gender, inclusion: { in: genders.keys }, :allow_blank => true

  private

  # If a user chooses to compete for prizes then they must be located in the US and be in school.
  # When a user is not in school the frontend sets the value to 0 and when they are located out
  # of the USA the state is set to NA.
  def clear_compete_for_prizes
    if year_in_school.eql? 0 or state.eql? "NA"
      self.compete_for_prizes = false
      nil # http://apidock.com/rails/ActiveRecord/RecordNotSaved
    end
  end

  # When a new user is created, check to see if the users email has been invited to any teams.
  def link_to_invitations
    UserInvite.where(email: self.email).each do |invite|
      invite.user = self
      invite.save
    end
  end
end
