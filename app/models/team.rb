# Team model for holding the main user list and all invites and requests to a team.
class Team < ActiveRecord::Base
  has_many :users
  has_many :user_invites
  has_many :user_requests
  belongs_to :team_captain, class_name: 'User'
  accepts_nested_attributes_for :user_invites
  validates :team_name, :affiliation, presence: true
  validates :team_name, uniqueness: { case_sensitive: false }

  after_save :set_team_captain

  # Returns whether everyone on the team is currently eligible for prize money.
  def eligible_for_prizes?
    eligible = true
    users.each do |user|
      eligible = false unless user.compete_for_prizes
    end
    eligible
  end

  # A team is only allowed to hold 5 players at the most. If the user count is 5 (or above which should
  # never happen) then mark the team as full.
  def full?
    users.count >= 5
  end

  private

  # If a team doesn't have a team captain but does have a user, set the team captain to the first user.
  def set_team_captain
    return unless team_captain.nil? && !users.empty?
    update_attribute(:team_captain, users.first)
  end
end
