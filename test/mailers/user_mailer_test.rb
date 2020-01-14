require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::SanitizeHelper

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end

  def setup
    @game = create(:active_game, enable_completion_certificates: true)
    @user_invite = create(:user_invite)
    @user_request = create(:user_request)
    @division = @game.divisions.first
    @teams = create_list(:team, 5, division: @division, compete_for_prizes: true)
    @first_place_team = @teams.first
    @first_place_user = @first_place_team.team_captain
    create(:solved_challenge, team: @first_place_team, challenge: create(:challenge, point_value: 1000))
    @second_place_team = @teams.second
    @second_place_user = @second_place_team.team_captain
    create(:solved_challenge, team: @second_place_team, challenge: create(:challenge, point_value: 500))
    # Is there a sane way to check to see if the URL provided is right without
    # typing the whole email in HTML?
    @rank_email_body = strip_tags("Hello #{@second_place_user.full_name}! Congratulations on completing #{@game.title}!
                   Your team, #{@second_place_team.team_name} came ranked 2nd.").squish
    @first_place_email_body = strip_tags("Hello #{@first_place_user.full_name}! Congratulations on completing #{@game.title}!
                   Your team, #{@first_place_team.team_name} came ranked 1st.").squish
    @open_source_email_body = strip_tags("Hello #{@first_place_user.full_name}! All solved challenges from #{@game.title} have been released with solutions
                   here. Have a great day!").squish
  end

  test 'user invite email' do
    @inv_email_body = strip_tags("Hello #{@user_invite.email}! You have been
                   invited to join the team #{@user_invite.team.team_name}
                   for the upcoming #{@game.organization} #{@game.title} Click the link below to register
                   an account in order to accept the invitation. #{link_to '
                   Create my account', new_user_registration_url(:email => @user_invite.email)}").squish

    email = UserMailer.invite_user(@user_invite).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal [@game.do_not_reply_email], email.from
    assert_equal [@user_invite.email], email.to
    assert_equal "#{@game.title}: Invite to join team #{@user_invite.team.team_name}", email.subject
    assert_equal @inv_email_body, strip_tags(email.body.to_s).squish
  end

  test 'user request email' do
    @reg_email_body = strip_tags("Hello #{@user_request.team.team_captain.full_name}!
                   #{@user_request.user.full_name}
                   has requested to join your team #{@user_request.team.team_name}
                   Click the link below to view and accept or reject the request.
                   #{link_to 'View Team Dashboard', team_url(@user_request.team)}").squish

    email = UserMailer.user_request(@user_request).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal [@game.do_not_reply_email], email.from
    assert_equal [@user_request.team.team_captain.email], email.to
    assert_equal "#{@game.title}: Request from #{@user_request.user.full_name} to join #{@user_request.team.team_name}", email.subject
    assert_equal @reg_email_body, strip_tags(email.body.to_s).squish
  end

  test 'competition reminder' do
    @remind_email_body = strip_tags("Hello #{@first_place_user.full_name}! This is a reminder for the
                   upcoming #{@game.organization} #{@game.title} which will start at #{@game.start}.
                   Click the link below to login and check your account #{link_to @game.title, home_index_url}.").squish

    email = UserMailer.competition_reminder(@first_place_user).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal [@game.do_not_reply_email], email.from
    assert_equal [@first_place_user.email], email.to
    assert_equal "#{@game.title}: Competition Reminder", email.subject
    assert_equal @remind_email_body, strip_tags(email.body.to_s).squish
  end

  test 'ranking no employment' do
    email = UserMailer.ranking(@second_place_user).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal [@game.do_not_reply_email], email.from
    assert_equal [@second_place_user.email], email.to
    assert_equal "#{@game.title}: Congratulations!", email.subject
    assert_equal true, email.has_attachments?
    assert_includes (strip_tags(email.body.parts.first.body.raw_source).squish), @rank_email_body
    assert_not_includes (strip_tags(email.body.parts.first.body.raw_source).squish), @game.recruitment_text
  end

  test 'ranking with user interested in employment and game having no employment information' do
    @second_place_user.update(interested_in_employment: true)

    email = UserMailer.ranking(@second_place_user).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal [@game.do_not_reply_email], email.from
    assert_equal [@second_place_user.email], email.to
    assert_equal "#{@game.title}: Congratulations!", email.subject
    assert_equal true, email.has_attachments?
    assert_includes (strip_tags(email.body.parts.first.to_s).squish), @rank_email_body
    assert_not_includes (strip_tags(email.body.parts.first.to_s).squish), @game.recruitment_text
  end

  test 'ranking with user interested in employment and game having employment information' do
    @second_place_user.update(interested_in_employment: true)
    @game.update(participant_recruitment_url: Faker::Internet.url(host: 'mitre.org'))

    email = UserMailer.ranking(@second_place_user).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal [@game.do_not_reply_email], email.from
    assert_equal [@second_place_user.email], email.to
    assert_equal "#{@game.title}: Congratulations!", email.subject
    assert_equal true, email.has_attachments?
    assert_includes (strip_tags(email.body.parts.first.to_s).squish), @rank_email_body
    assert_includes (strip_tags(email.body.parts.first.to_s).squish), @game.recruitment_text
  end

  test 'ranking email for first place with scholarships available' do
    @game.update(scholarships_available: true)
    email = UserMailer.ranking(@first_place_user).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal [@game.do_not_reply_email], email.from
    assert_equal [@first_place_user.email], email.to
    assert_equal "#{@game.title}: Congratulations!", email.subject
    assert_equal true, email.has_attachments?
    assert_includes (strip_tags(email.body.parts.first.to_s).squish), @game.prizes_text
  end

  test 'ranking email for first place with user not interested in employment and game has recruitment no scholarships' do
    @game.update(participant_recruitment_url: Faker::Internet.url(host: 'mitre.org'))
    @first_place_user.update(interested_in_employment: false)
    email = UserMailer.ranking(@first_place_user).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal [@game.do_not_reply_email], email.from
    assert_equal [@first_place_user.email], email.to
    assert_equal "#{@game.title}: Congratulations!", email.subject
    assert_equal true, email.has_attachments?
    assert_includes (strip_tags(email.body.parts.first.to_s).squish), @first_place_email_body
    assert_not_includes (strip_tags(email.body.parts.first.to_s).squish), @game.recruitment_text
    assert_not_includes (strip_tags(email.body.parts.first.to_s).squish), @game.prizes_text
  end

  test 'ranking email for first place with user interested in employment and game has recruitment no scholarships' do
    @game.update(participant_recruitment_url: Faker::Internet.url(host: 'mitre.org'))
    @first_place_user.update(interested_in_employment: true)
    email = UserMailer.ranking(@first_place_user).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal [@game.do_not_reply_email], email.from
    assert_equal [@first_place_user.email], email.to
    assert_equal "#{@game.title}: Congratulations!", email.subject
    assert_equal true, email.has_attachments?
    assert_includes (strip_tags(email.body.parts.first.to_s).squish), @first_place_email_body
    assert_includes (strip_tags(email.body.parts.first.to_s).squish), @game.recruitment_text
    assert_not_includes (strip_tags(email.body.parts.first.to_s).squish), @game.prizes_text
  end

  test 'ranking email for first with user not interested in employment and game does not have recruitment' do
    @first_place_user.update(interested_in_employment: false)
    email = UserMailer.ranking(@first_place_user).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal [@game.do_not_reply_email], email.from
    assert_equal [@first_place_user.email], email.to
    assert_equal "#{@game.title}: Congratulations!", email.subject
    assert_equal true, email.has_attachments?
    assert_includes (strip_tags(email.body.parts.first.to_s).squish), @first_place_email_body
    assert_not_includes (strip_tags(email.body.parts.first.to_s).squish), @game.recruitment_text
  end

  test 'ranking email for first with user interested in employment and game does not have recruitment' do
    @first_place_user.update(interested_in_employment: true)
    email = UserMailer.ranking(@first_place_user).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal [@game.do_not_reply_email], email.from
    assert_equal [@first_place_user.email], email.to
    assert_equal "#{@game.title}: Congratulations!", email.subject
    assert email.has_attachments?
    assert_includes (strip_tags(email.body.parts.first.to_s).squish), @first_place_email_body
    assert_not_includes (strip_tags(email.body.parts.first.to_s).squish), @game.recruitment_text
  end

  test 'ranking no certificate' do
    @game.update!(enable_completion_certificates: false)
    email = UserMailer.ranking(@first_place_user).deliver_now
    assert_not email.has_attachments?
  end

  test 'ranking with certificate' do
    @game.update!(enable_completion_certificates: true)
  end

  test 'open source email' do
    email = UserMailer.open_source(@first_place_user).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal [@game.do_not_reply_email], email.from
    assert_equal [@first_place_user.email], email.to
    assert_equal "#{@game.title}: Challenges Released", email.subject
    assert_equal @open_source_email_body, strip_tags(email.body.to_s).squish
  end
end
