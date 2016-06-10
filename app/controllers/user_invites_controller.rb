class UserInvitesController < ApplicationController
  before_action :check_access, only: [:destroy]

  # Method for a free agent user to accept a team invitation.
  def accept
    @user_invite = current_user.user_invites.find(params[:id])
    if @user_invite.nil?
      redirect_to :back, alert: I18n.t('invites.invalid_permissions')
    elsif @user_invite.accept
      redirect_to team_path(@user_invite.team), notice: I18n.t('invites.accepted_successful')
    else
      redirect_to :back, alert: I18n.t('invites.full_team')
    end
  end

  # Method for either a team captain or a user to revoke an invitation.
  def destroy
    @user_invite.status = :Rejected
    @user_invite.save
    redirect_to :back, notice: I18n.t('invites.rejected_successful')
  end

  private

  # Only allow team captain and the user invited to deleted a user invite.
  def check_access
    @user_invite = UserInvite.find(params[:id])
    unless @user_invite.user.eql?(current_user) || @user_invite.team.team_captain.eql?(current_user)
      raise ActiveRecord::RecordNotFound
    end
  end
end
