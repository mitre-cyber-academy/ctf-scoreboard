class User < ActiveRecord::Base
  belongs_to :team
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :password, :password_confirmation, :remember_me, :team_id, :team_captain, :email, :name, :school, :year_in_school, :gender, :age, :area_of_study, :location, :personal_email

  validates_presence_of :name, :school, :password, :password_confirmation, :if => :final_registration_step?
  validates_inclusion_of :year_in_school, :in => [9, 10, 11, 12], :presence => true, :if => :final_registration_step?
  validates_inclusion_of :gender, :in => ['M','F'], :allow_blank => true

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
