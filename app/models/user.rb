class User < ActiveRecord::Base
  belongs_to :team
  has_attached_file :resume, :path => ":rails_root/files/:attachment/:id/:style/:basename.:extension"
  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Not sure if this will work
  validates :email, presence: true, length: { maximum: 50 },
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  #validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :update

  #makes sure the passwords are 10 characters long

  #Why is it that when I try to use this, it won't work? => Can't regesiter a new user, it checks for the password
  #validates :password, presence: true, length: { minimum: 10}

  validates_presence_of :resume, :name, :school, :password, :password_confirmation, :if => :final_registration_step?, presence: true
  validates_inclusion_of :year_in_school, :in => [9, 10, 11, 12, 13, 14, 15, 16], :presence => true, :if => :final_registration_step?
  validates_inclusion_of :gender, :in => ['M','F'], :allow_blank => true
  #validates_inclusion_of :play_for_money, :in => ['Y','N'], :allow_blank => false
  #do_not_validate_attachment_file_type :resume
  do_not_validate_attachment_file_type :resume
  # How do I have a message come up saying you can't uplaod a file without the correct extension
  validates :verification, :matches => [/pdf\f/, /rtf\f/,/doc\f/,/docx\f/]

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
