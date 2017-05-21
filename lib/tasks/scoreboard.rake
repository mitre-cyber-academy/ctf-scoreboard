namespace :scoreboard do
  desc "Recreates key file requests for all registered users"
  task create_key_requests: :environment do
    User.all.each do |user|
      user.create_vpn_key_request
    end
  end

end
