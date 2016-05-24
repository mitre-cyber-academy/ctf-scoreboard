class User < ActiveRecord::Base
  belongs_to :team
  has_one :user_invite
  has_many :user_requests
  before_validation { self.email = email.downcase }
  before_save :clear_compete_for_prizes
  enum gender: [ :Male, :Female ]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :secure_validatable

  validates_presence_of :full_name, :affiliation, :state, presence: true
  validates_inclusion_of :year_in_school, :in => [0, 9, 10, 11, 12, 13, 14, 15, 16], :presence => true
  validates :gender, inclusion: { in: genders.keys }, :allow_blank => true

  private

  # If a user chooses to compete for prizes then they must be located in the US and be in school.
  # When a user is not in school the frontend sets the value to 0 and when they are located out
  # of the USA the state is set to NA.
  def clear_compete_for_prizes
    if year_in_school.eql? 0 or state.eql? "NA"
      compete_for_prizes = false
    end
  end
end
