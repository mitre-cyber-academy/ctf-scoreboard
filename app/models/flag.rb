# frozen_string_literal: true

class Flag < ActiveRecord::Base
  belongs_to :challenge, inverse_of: :flags

  validates :flag, presence: true

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
