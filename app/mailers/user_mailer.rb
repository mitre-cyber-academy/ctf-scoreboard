# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def invite_user(user_invite)
    @invite = user_invite
    @team = @invite.team
    mail(to: @invite.email, subject: I18n.t('user_mailer.invite_user.title', title: @game.title, teamname: @team.team_name))
  end

  def user_request(user_request)
    @team = user_request.team
    @captain = @team.team_captain
    @user = user_request.user
    mail(to: @captain.email, subject: I18n.t('user_mailer.user_request.title', title: @game.title, fullname: @user.full_name, teamname: @team.team_name))
  end

  def competition_reminder(user)
    @user = user
    mail(to: @user.email, subject: I18n.t('user_mailer.completion_reminder.title', title: @game.title))
  end

  # Assumes user is on a team
  def ranking(user, rank = nil)
    @user = user
    @team = @user.team
    @div = @team.division
    @rank = rank || @team.find_rank

    attachments['Competition Certificate.pdf'] = @user.generate_certificate(@rank).read if @game.enable_completion_certificates

    mail(to: @user.email, subject: I18n.t('user_mailer.ranking.title', title: @game.title))
  end

  def open_source(user)
    @user = user
    mail(to: @user.email, subject: I18n.t('user_mailer.open_source.title', title: @game.title))
  end

  def message_notification(user, message)
    @user = user
    @message = message
    mail(to: @user.email, subject: I18n.t('user_mailer.message_notification.title', title: @game.title, messagetitle: @message.title))
  end
end
