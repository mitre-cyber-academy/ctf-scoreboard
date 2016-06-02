class UserInvitesController < ApplicationController
  before_filter :check_access, only: [:destroy]

  # Method for a free agent user to accept a team invitation.
  def accept
    @user_invite = current_user.user_invites.find(params[:id])
    if !@user_invite.nil?
      @user_invite.status = :Accepted
      @user_invite.save
      @user_invite.team.users << @user_invite.user
      redirect_to team_path(@user_invite.team), :notice => 'User invite was successfully accepted.'
    else
      redirect_to :back, :alert => 'You do not have permission to accept this invite.'
    end
  end

  # Method for either a team captain or a user to revoke an invitation.
  def destroy
    @user_invite.status = :Rejected
    @user_invite.save
    redirect_to :back, :notice => 'User invitation was successfully rejected.'
  end

  private

  # Only allow team captain and the user invited to deleted a user invite.
  def check_access
    @user_invite = UserInvite.find(params[:id])
    if !(@user_invite.user.eql? current_user or @user_invite.team.team_captain.eql? current_user)
      raise ActiveRecord::RecordNotFound
    end
  end
end