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
                   Create my account', new_user_registration_url(:email => user_invites(:invite_one).email)}").squish
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
    assert_equal ['mitrectf+user2@gmail.com'], email.to
    assert_equal "MITRE CTF: Invite to join team #{user_invites(:invite_one).team.team_name}", email.subject
    assert_equal @inv_email_body, strip_tags(email.body.to_s).squish
  end

  test 'invite contains correct url' do
  end

  test 'request' do
    email = UserMailer.user_request(user_requests(:request_one)).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal ['do-not-reply@mitrecyberacademy.org'], email.from
    assert_equal ['mitrectf+user1test@gmail.com'], email.to
    assert_equal "MITRE CTF: Request from #{user_requests(:request_one).user.full_name} to join #{user_requests(:request_one).team.team_name}", email.subject
    assert_equal @reg_email_body, strip_tags(email.body.to_s).squish
  end

  test 'send_credentials' do
    team = teams(:full_team)
    password = "test_password123456"
    email = UserMailer.send_credentials(team, team.scoreboard_login_name, password).deliver_now
    email_stripped_body = strip_tags(email.body.to_s)

    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal ['do-not-reply@mitrecyberacademy.org'], email.from
    assert_equal team.users.collect(&:email), email.to
    assert_equal 'MITRE CTF: Login Credentials for the upcoming CTF', email.subject
    assert email_stripped_body.include? "Username:\n\n#{team.scoreboard_login_name}"
    assert email_stripped_body.include? "Password:\n\n#{password}"
    assert email_stripped_body.include? team.team_name
  end
end
