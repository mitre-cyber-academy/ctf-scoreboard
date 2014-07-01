class Vip < ActiveRecord::Base
  attr_accessible :company, :email, :name, :phone, :confirmation_token, :confirmed, :why_are_you_a_vip, :manually_approved
  validates_presence_of :company, :email, :name, :phone, :why_are_you_a_vip
  validates_uniqueness_of :email
  before_create :generate_token

  protected

  def generate_token
    begin
      token = SecureRandom.urlsafe_base64
    end while Vip.where(:confirmation_token => token).exists?
    self.confirmation_token = token
  end
end
