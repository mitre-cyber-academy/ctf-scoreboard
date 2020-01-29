require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::SanitizeHelper

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end

  def setup
    @game = create(:active_jeopardy_game, enable_completion_certificates: true)
    @user_invite = create(:point_user_invite)
    @user_request = create(:point_user_request)
    @division = @game.divisions.first
    @teams = create_list(:point_team, 5, division: @division, compete_for_prizes: true)
    @first_place_team = @teams.first
    @first_place_user = @first_place_team.team_captain
    create(:point_solved_challenge, team: @first_place_team, challenge: create(:point_challenge, point_value: 1000))
    @second_place_team = @teams.second
    @second_place_user = @second_place_team.team_captain
    @solved_challenge = create(:point_solved_challenge, team: @second_place_team, challenge: create(:point_challenge, point_value: 500))
  end

  test 'invite user exists' do
    user = create(:user)
    user_invite = create(:point_user_invite, email: user.email)
    email = UserMailer.invite_user(user_invite).deliver_now
    assert_equal [@game.do_not_reply_email], email.from
    assert_equal [user_invite.email], email.to
    assert_equal "#{@game.title}: Invite to join team #{user_invite.team.team_name}", email.subject
    assert_not_includes email.body.to_s, 'Create my account'
    assert_includes email.body.to_s, 'View invitation'
  end

  test 'invite user does not exist' do
    email = UserMailer.invite_user(@user_invite).deliver_now

    assert_equal [@game.do_not_reply_email], email.from
    assert_equal [@user_invite.email], email.to
    assert_equal "#{@game.title}: Invite to join team #{@user_invite.team.team_name}", email.subject
    assert_includes email.body.to_s, 'Create my account'
    assert_not_includes email.body.to_s, 'View invitation'
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
  end

  test 'ranking basic rank' do
    email = UserMailer.ranking(@first_place_user).deliver_now
    email = remove_html_artifacts(strip_tags(email.body.parts.first.to_s))
    assert_includes email, 'ranked 1st'
  end

  test 'ranking first place team eligible and prizes available and prize text not blank' do
    @game.update(prizes_available: true)
    email = UserMailer.ranking(@first_place_user).deliver_now
    email = remove_html_artifacts(strip_tags(email.body.parts.first.to_s))
    assert_includes email, @game.prizes_text
  end

  test 'ranking first place team eligible and prizes not available' do
    email = UserMailer.ranking(@first_place_user).deliver_now
    email = remove_html_artifacts(strip_tags(email.body.parts.first.to_s))
    assert_not_includes email, @game.prizes_text
  end

  test 'ranking first place team not eligible' do
    @first_place_user.update(compete_for_prizes: false)
    email = UserMailer.ranking(@first_place_user).deliver_now
    email = remove_html_artifacts(strip_tags(email.body.parts.first.to_s))
    assert_not_includes email, @game.prizes_text
  end

  test 'ranking second place team' do
    email = UserMailer.ranking(@second_place_user).deliver_now
    email = remove_html_artifacts(strip_tags(email.body.parts.first.to_s))
    assert_not_includes email, @game.prizes_text
    assert_includes email, 'ranked 2nd'
  end

  test 'ranking team with no points' do
    FeedItem.delete(@solved_challenge)
    email = UserMailer.ranking(@second_place_user).deliver_now
    email = remove_html_artifacts(strip_tags(email.body.parts.first.to_s))
    assert_not_includes email, @game.recruitment_text
  end

  test 'ranking team with points and user not interested in employment' do
    email = UserMailer.ranking(@first_place_user).deliver_now
    email = remove_html_artifacts(strip_tags(email.body.parts.first.to_s))
    assert_not_includes email, @game.recruitment_text
  end

  test 'ranking team with points and user interested in employment and recruitment text is blank' do
    recruitment_text = @game.recruitment_text
    @game.update(recruitment_text: nil)
    email = UserMailer.ranking(@first_place_user).deliver_now
    email = remove_html_artifacts(strip_tags(email.body.parts.first.to_s))
    assert_not_includes email, recruitment_text
  end

  test 'ranking team with points and user interested in employment and recruitment text is not blank' do
    @first_place_user.update(interested_in_employment: true)
    email = UserMailer.ranking(@first_place_user).deliver_now
    email = remove_html_artifacts(strip_tags(email.body.parts.first.to_s))
    assert_includes email, @game.recruitment_text
  end

  test 'ranking without certificates' do
    @game.update!(enable_completion_certificates: false)
    email = UserMailer.ranking(@first_place_user).deliver_now
    assert_not email.has_attachments?
  end

  test 'ranking with certificates' do
    @game.update!(enable_completion_certificates: true)
    email = UserMailer.ranking(@first_place_user).deliver_now
    assert email.has_attachments?
  end

  test 'open source email' do
    email = UserMailer.open_source(@first_place_user).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal [@game.do_not_reply_email], email.from
    assert_equal [@first_place_user.email], email.to
    assert_equal "#{@game.title}: Challenges Released", email.subject
  end
end
