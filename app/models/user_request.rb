# frozen_string_literal: true

# Whenever a user requests to join a team a new user request is created.
class UserRequest < ApplicationRecord
  belongs_to :team, required: true
  belongs_to :user, required: true

  enum status: %i[Pending Accepted Rejected]

  after_create :send_email

  validates :status, inclusion: { in: statuses.keys, allow_blank: true }

  validates :team, :user, presence: true

  validate :uniqueness_of_pending_request, on: :create

  scope :pending_requests, -> { where(status: 'Pending') }

  # Get only invites in the pending status where the user is not already on a team.
  scope :pending, -> { pending_requests.joins(:user).where(users: { team_id: nil }) }

  # Make sure a user cannot be invited to the same team over and over.
  def uniqueness_of_pending_request
    return true if UserRequest.pending_requests.where(team: team, user: user).empty?
    errors.add(:user, I18n.t('requests.already_pending'))
  end

  def user_on_team?
    !user.team.nil?
  end

  def accept
    if team.full?
      false
    elsif user_on_team? # Check to make sure user isn't already on a team.
      false
    else
      update_attributes(status: :Accepted)
      team.users << user
    end
  end

  private

  def send_email
    UserMailer.user_request(self).deliver_later
  end
end
