# frozen_string_literal: true

class ChallengesController < ApplicationController
  include ChallengesHelper

  before_action :enforce_access
  before_action :find_challenge

  def show
    @solved_challenge = @challenge.solved_by_user?(current_user)
    @solved_video_url = @challenge.get_video_url_for_flag(current_user)
    @solved_by = @challenge.solved_challenges.order(:created_at).reverse_order
    flash.now[:notice] = I18n.t('flag.accepted') if @solved_challenge
  end

  def update
    flag = params[:challenge][:submitted_flag]
    SubmittedFlag.create(user: current_user, challenge: @challenge, text: flag) unless current_user.admin?
    flag_found = @challenge.find_flag(flag)

    if flag_found
      @solved_challenge = flag_found.save_solved_challenge(current_user)
      @solved_video_url = flag_found.video_url
      flash.now[:notice] = I18n.t('flag.accepted')
    else
      flash.now[:error] = wrong_flag_messages.sample
    end
    @solved_by = @challenge.solved_challenges.order(:created_at).reverse_order

    render :show
  end

  private

  def find_challenge
    @challenge = Game.instance.challenges.find(params[:id])
    raise ActiveRecord::RecordNotFound if !current_user.admin? && !@challenge.open?
  end
end
