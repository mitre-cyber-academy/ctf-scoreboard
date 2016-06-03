# Every time a team captain invites a user to their team, a new user invite is created

class UserInvite < ActiveRecord::Base
  belongs_to :team
  belongs_to :user

  enum status: [ :Pending, :Accepted, :Rejected ]

  after_create :send_email, :link_to_user

  before_validation { self.email = self.email.downcase }

  validates_presence_of :email, :team

  validates :email, :email => true

  validates :status, inclusion: { in: statuses.keys }

  # Get only invites in the pending status.
  scope :pending, -> {where(status: 'Pending')}

  def accept
    if team.full?
      false
    else
      update_attribute(:status, :Accepted)
      team.users << user
    end
  end

  private

  def send_email
    UserMailer.invite_user(self).deliver_now
  end

  def link_to_user
    update_attribute(:user, User.find_by_email(self.email))
  end
end
