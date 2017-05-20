# frozen_string_literal: true

class UserInvitesController < ApplicationController
  include ApplicationModule

  before_action :user_logged_in?
  before_action :load_game, :load_message_count
  before_action :block_admin_action, only: [:accept]
  before_action :check_accept_access, only: [:accept]
  before_action :check_destroy_access, only: [:destroy]

  # Method for a free agent user to accept a team invitation.
  def accept
    if @user_invite.accept
      redirect_to team_path(@user_invite.team), notice: I18n.t('invites.accepted_successful')
    else
      redirect_back(fallback_location: join_team_users_path, alert: I18n.t('invites.full_team'))
    end
  end

  # Method for either a team captain or a user to revoke an invitation.
  def destroy
    @user_invite.status = :Rejected
    @user_invite.save
    redirect_back(fallback_location: user_root_path, notice: I18n.t('invites.rejected_successful'))
  end

  private

  # Only allow user invited to accept a user invite.
  def check_accept_access
    @user_invite = current_user.user_invites.find_by id: params[:id]
    redirect_back(fallback_location: user_root_path, alert: I18n.t('invites.invalid_permissions')) if @user_invite.nil?
  end

  # Only allow team captain and the user invited to delete a user invite.
  def check_destroy_access
    @user_invite = UserInvite.find_by id: params[:id]
    return true if @user_invite.user.eql?(current_user) || @user_invite.team.team_captain.eql?(current_user)
    raise ActiveRecord::RecordNotFound
  end
end
