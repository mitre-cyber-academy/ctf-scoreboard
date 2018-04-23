# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def invite_user(user_invite)
    @invite = user_invite
    @team = @invite.team
    mail(to: @invite.email, subject: "MITRE CTF: Invite to join team #{@team.team_name}")
  end

  def user_request(user_request)
    @team = user_request.team
    @captain = @team.team_captain
    @user = user_request.user
    mail(to: @captain.email, subject: "MITRE CTF: Request from #{@user.full_name} to join #{@team.team_name}")
  end

  def competition_reminder(user)
    @user = user
    @game = Game.instance
    mail(to: @user.email, subject: 'MITRE CTF: Competition Reminder')
  end

  # Assumes user is on a team
  def ranking(user, rank = nil)
    @user = user
    @team = @user.team
    @div = user.team.division
    rank = 1 + (@div.ordered_teams.index @team) if rank.nil?
    @rank = rank
    attachment = @user.generate_certificate(rank)

    attachments['Competition Certificate.pdf'] = attachment.read unless attachment.nil?

    mail(to: @user.email, subject: 'MITRE CTF: Congratulations!')
  end

  def open_source(user)
    @user = user
    mail(to: @user.email, subject: 'MITRE CTF: Challenges Released')
  end

  def message_notification(user, message)
    @user = user
    @message = message
    mail(to: @user.email, subject: "MITRE CTF New Message: #{message.title}")
  end
end
