class Team < ActiveRecord::Base
  has_many :users
  has_many :user_invites
  has_many :user_requests
  belongs_to :team_captain, :class_name => 'User'
  accepts_nested_attributes_for :user_invites
  validates_presence_of :team_name, :affiliation
  validates_uniqueness_of :team_name

  after_save :set_team_captain

  # Returns whether everyone on the team is currently eligible for prize money.
  def eligible_for_prizes?
    eligible = true
    users.each do |user|
      if !user.compete_for_prizes
        eligible = false
      end
    end
    eligible
  end

  private

  # If a team doesn't have a team captain, set the team captain to the first user.
  def set_team_captain
    if team_captain.nil?
      team_captain = users.first
      save
    end
  end
end
