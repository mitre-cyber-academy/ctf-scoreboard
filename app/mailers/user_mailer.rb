# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def invite_user(user_invite)
    @invite = user_invite
    @team = @invite.team
    @game = Game.instance
    mail(to: @invite.email, subject: "#{@game.title}: Invite to join team #{@team.team_name}")
  end

  def user_request(user_request)
    @team = user_request.team
    @captain = @team.team_captain
    @user = user_request.user
    @game = Game.instance
    mail(to: @captain.email, subject: "#{@game.title}: Request from #{@user.full_name} to join #{@team.team_name}")
  end

  def competition_reminder(user)
    @user = user
    @game = Game.instance
    mail(to: @user.email, subject: "#{@game.title}: Competition Reminder")
  end

  # Assumes user is on a team
  def ranking(user, rank = nil)
    @user = user
    @team = @user.team
    @div = @team.division
    @rank = 1 + (@div.ordered_teams.index @team) if rank.nil?

    if @game.enable_completion_certificates
      attachments['Competition Certificate.pdf'] = @user.generate_certificate(@rank).read
    end

    mail(to: @user.email, subject: "#{@game.title}: Congratulations!")
  end

  def open_source(user)
    @user = user
    @game = Game.instance
    mail(to: @user.email, subject: "#{@game.title}: Challenges Released")
  end

  def message_notification(user, message)
    @user = user
    @message = message
    @game = Game.instance
    mail(to: @user.email, subject: "#{@game.title} New Message: #{message.title}")
  end
end
