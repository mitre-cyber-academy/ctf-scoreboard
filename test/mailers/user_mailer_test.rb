require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::SanitizeHelper

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end

  def setup
    # Is there a sane way to check to see if the URL provided is right without
    # typing the whole email in HTML?
    @inv_email_body = strip_tags("Hello #{user_invites(:invite_one).email}! You have been
                   invited to join the team #{user_invites(:invite_one).team.team_name}
                   for the upcoming MITRE CTF Click the link below to register
                   an account in order to accept the invitation. #{link_to '
                   Create my account', new_user_registration_url}").squish
    @reg_email_body = strip_tags("Hello #{user_requests(:request_one).team.team_captain.email}!
                   #{user_requests(:request_one).user.full_name}
                   has requested to join your team #{user_requests(:request_one).team.team_name}
                   Click the link below to view and accept or reject the request.
                   #{link_to 'View Team Dashboard', team_url(user_requests(:request_one).team)}").squish
  end

  test 'invite' do
    email = UserMailer.invite_user(user_invites(:invite_one)).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal ['do-not-reply@mitrecyberacademy.org'], email.from
    assert_equal ['user2@domain.com'], email.to
    assert_equal "MITRE CTF: Invite to join team #{user_invites(:invite_one).team.team_name}", email.subject
    assert_equal @inv_email_body, strip_tags(email.body.to_s).squish
  end

  test 'request' do
    email = UserMailer.user_request(user_requests(:request_one)).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal ['do-not-reply@mitrecyberacademy.org'], email.from
    assert_equal ['user1@test.com'], email.to
    assert_equal "MITRE CTF: Request from #{user_requests(:request_one).user.full_name} to join #{user_requests(:request_one).team.team_name}", email.subject
    assert_equal @reg_email_body, strip_tags(email.body.to_s).squish
  end
end
