class Challenge < ActiveRecord::Base
  belongs_to :category
  has_many :flags, inverse_of: :challenge
  has_many :solved_challenges
  has_many :submitted_flags
end
