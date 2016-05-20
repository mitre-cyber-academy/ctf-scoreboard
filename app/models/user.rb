class User < ActiveRecord::Base
  belongs_to :team
  before_validation { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A.+@.+\..+\z/i
  enum gender: [ :Male, :Female ]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: true

  validates :password, presence: true, length: { minimum: 10 }, :if => :final_registration_step?

  validates_presence_of :resume, :name, :school, :password, :password_confirmation, :if => :final_registration_step?, presence: true
  validates_inclusion_of :year_in_school, :in => [0, 9, 10, 11, 12, 13, 14, 15, 16], :presence => true, :if => :final_registration_step?
  validates :gender, inclusion: { in: genders.keys }, :allow_blank => true

  def password_required?
    super if confirmed?
  end

  def final_registration_step?
    !confirmation_token.nil?
  end

  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end
end
