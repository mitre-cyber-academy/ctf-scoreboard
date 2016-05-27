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
    mail(to: @captain.email, subject: "MITRE CTF: Request from #{@user.full_name} to join #{@team.name}")
  end
end
