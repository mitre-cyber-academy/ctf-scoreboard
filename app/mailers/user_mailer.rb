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

  def send_credentials(team, team_username, team_password)
    @team = team
    @team_username = team_username
    @team_password = team_password
    @scoreboard_url = 'https://scoreboard.mitrestemctf.org'

    subject = 'MITRE CTF: Login Credentials for the upcoming CTF'
    mail(to: @team.users.collect(&:email), subject: subject)
  end
end
