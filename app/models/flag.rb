# frozen_string_literal: true

class Flag < ActiveRecord::Base
  belongs_to :challenge, inverse_of: :flags

  has_many :solved_challenges

  validates :flag, presence: true

  def save_solved_challenge(user)
    invoke_api_request

    # solved_challenges.create(user: user, team: user.team, challenge: challenge, division: user.team.division) unless user.admin?
    solved_challenges.create(user: user, team: user.team, challenge: challenge) unless user.admin?
  end

  def invoke_api_request
    # Make API call if one is specified. This throws away any failed requests
    # since we really don't care that much if the actions really happen. The
    # player properly being credited their points is more important.
    Thread.new do
      begin
        Net::HTTP.get(URI.parse(api_request)) if api_request
      # Could list all the execeptions, most advice advocates to move
      # to a 3rd party HTTP library that has errors derived from a common
      # superclass
      rescue StandardError
        logger.info "Error invoking api request for flag submission #{self}"
      end
    end
  end
end
