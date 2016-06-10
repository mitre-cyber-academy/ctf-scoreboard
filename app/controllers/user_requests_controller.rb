class UserRequestsController < ApplicationController
  include ApplicationHelper, UserHelper

  before_action :user_logged_in?
  before_action :check_if_user_on_team, only: [:create]
  before_action :captain_of_team_requested, only: [:accept]
  before_action :check_if_able_to_reject, only: [:destroy]

  # Allows a user to create a new request to join a team.
  def create
    @request = UserRequest.new(user: current_user, team_id: params[:team_id])
    if @request.save
      redirect_to user_root_path, notice: I18n.t('registration.requests.sent_successful')
    else
      redirect_to user_root_path, alert: @request.errors.full_messages.first
    end
  end

  # Allows the captain of a team to accept a request to join a team.
  def accept
    if @user_request.user_on_team?
      redirect_to :back, alert: I18n.t('registration.requests.accepted_another')
    elsif @user_request.accept
      redirect_to team_path(@user_request.team), notice: I18n.t('registration.requests.accepted_successful')
    else
      redirect_to :back, alert: I18n.t('registration.request.too_many_players')
    end
  end

  # Allows the team captain to reject a request to join a team.
  def destroy
    @user_request.status = :Rejected
    if @user_request.save
      redirect_to :back, notice: I18n.t('registration.requests.rejected_sucessful')
    else
      redirect_to user_root_path, alert: @user_request.errors.full_messages.first
    end
  end

  private

  # Only the captain of the team specified on the user request is allowed to
  # accept the users request.
  def captain_of_team_requested
    @user_request = current_user.team.user_requests.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @user_request.team.team_captain.eql?(current_user)
  end

  # Only allow team captain and the user requesting to delete a user request.
  def check_if_able_to_reject
    @user_request = UserRequest.find(params[:id])
    unless @user_request.user.eql?(current_user) || @user_request.team.team_captain.eql?(current_user)
      raise ActiveRecord::RecordNotFound
    end
  end
end
