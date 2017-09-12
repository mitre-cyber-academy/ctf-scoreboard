# frozen_string_literal: true

namespace :scoreboard do
  desc 'Recreates key file requests for all registered users'
  task create_key_requests: :environment do
    User.all.each(&:create_vpn_cert_request)
  end
end
