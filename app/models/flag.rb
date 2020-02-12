# frozen_string_literal: true

class Flag < ApplicationRecord
  validates :flag, presence: true

  def self.type_enum
    [['ChallengeFlag'], ['PentestFlag']]
  end

  validates :type, inclusion: type_enum.flatten, presence: true

  def save_solved_challenge(user)
    invoke_api_request
    return if user.admin?

    solved_challenges.create!(user: user, team: user.team, challenge: challenge, division: user.team.division)
  end

  def invoke_api_request
    # Make API call if one is specified. This throws away any failed requests
    # since we really don't care that much if the actions really happen. The
    # player properly being credited their points is more important.
    Thread.new do
      Net::HTTP.get(URI.parse(api_request)) if api_request
      # Could list all the execeptions, most advice advocates to move
      # to a 3rd party HTTP library that has errors derived from a common
      # superclass
    rescue StandardError
      logger.info "Error invoking api request for flag submission #{self}"
    end
  end
end
