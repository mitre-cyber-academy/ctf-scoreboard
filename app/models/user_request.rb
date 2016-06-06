# Whenever a user requests to join a team a new user request is created.
class UserRequest < ActiveRecord::Base
  belongs_to :team
  belongs_to :user

  enum status: [:Pending, :Accepted, :Rejected]

  validates :status, inclusion: { in: statuses.keys, allow_blank: true }

  validates :team, :user, presence: true

  # Get only requests in the pending status.
  scope :pending, -> { where(status: 'Pending') }
end
