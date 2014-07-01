class Team < ActiveRecord::Base
  has_many :users
  belongs_to :team_captain, :class_name => 'User'
  accepts_nested_attributes_for :users, allow_destroy: false
  attr_accessible :team_name, :users_attributes, :affiliation
  validates_presence_of :team_name, :affiliation
  validates_uniqueness_of :team_name
end
