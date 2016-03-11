class User < ActiveRecord::Base
  belongs_to :team
  has_attached_file :Verification, :path => ":rails_root/files/:attachment/:id/:style/:basename.:extension"

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates_presence_of :Verification, :name, :school, :password, :password_confirmation, :if => :final_registration_step?
  validates_presence_of :Resume, :name, :school, :password, :password_confirmation, :if => :final_registration_step?
  validates_inclusion_of :year_in_school, :in => [9, 10, 11, 12, 13, 14, 15, 16], :presence => true, :if => :final_registration_step?
  validates_inclusion_of :compete_for_money, :in => ['Money', 'No Money'], :presence => true, :if => :final_registration_step?
  validates_inclusion_of :gender, :in => ['Yes','No'], :allow_blank => true
  do_not_validate_attachment_file_type :Verification
  do_not_validate_attachment_file_type :Resume

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
