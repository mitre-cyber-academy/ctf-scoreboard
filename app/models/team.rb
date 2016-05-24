class Team < ActiveRecord::Base
  has_many :users
  has_many :user_invites
  has_many :user_requests
  belongs_to :team_captain, :class_name => 'User'
  accepts_nested_attributes_for :user_invites, allow_destroy: true
  validates_presence_of :team_name, :affiliation
  validates_uniqueness_of :team_name
end
