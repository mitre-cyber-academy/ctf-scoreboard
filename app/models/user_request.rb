class UserRequest < ActiveRecord::Base
  belongs_to :team
  belongs_to :user

  enum status: [ :Pending, :Accepted, :Rejected ]

  validates :status, inclusion: { in: statuses.keys }

  validates_presence_of :team, :user

  # Get only requests in the pending status.
  scope :pending, -> {where(status: 'Pending')}
end
