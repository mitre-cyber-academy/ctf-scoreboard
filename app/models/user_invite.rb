# Every time a team captain invites a user to their team, a new user invite is created

class UserInvite < ActiveRecord::Base
  belongs_to :team
  belongs_to :user

  before_validation { self.email = email.downcase }

  validates_presence_of :email, :team

  validates_format_of :email,:with => Devise::email_regexp

  # When a user accepts an invite, a user ID will be added to the invite. If the user
  # id is nil then the invite is still pending.
  def pending?
    return self.user.nil?
  end
end
