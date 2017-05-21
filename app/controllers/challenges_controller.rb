# frozen_string_literal: true

class ChallengesController < ApplicationController
  include ChallengesHelper

  before_action :enforce_access
  before_action :load_game, :load_message_count
  before_action :find_challenge
  before_action :find_and_log_flag, :on_team?, only: [:update]

  def show
    @solved_challenge = @challenge.get_solved_challenge_for(current_user.team_id)
    @solved_video_url = @solved_challenge.flag.video_url if @solved_challenge
    @solved_by = @challenge.solved_challenges.order(:created_at).reverse_order
    flash.now[:notice] = I18n.t('flag.accepted') if @solved_challenge
  end

  def update
    if @flag_found
      @solved_challenge = @flag_found.save_solved_challenge(current_user)
      @solved_video_url = @flag_found.video_url
      flash.now[:notice] = I18n.t('flag.accepted')
    else
      flash.now[:alert] = wrong_flag_messages.sample
    end
    @solved_by = @challenge.solved_challenges.order(:created_at).reverse_order

    render :show
  end

  private

  def find_challenge
    @challenge = @game.challenges.find(params[:id])
    raise ActiveRecord::RecordNotFound if !current_user.admin? && !@challenge.open?
  end

  def find_and_log_flag
    flag = params[:challenge][:submitted_flag]
    SubmittedFlag.create(user: current_user, challenge: @challenge, text: flag) unless current_user.admin?
    @flag_found = @challenge.find_flag(flag)
  end

  def on_team?
    return true if current_user.on_a_team?
    redirect_to user_root_path, alert: I18n.t('challenge.must_be_on_team')
  end
end
