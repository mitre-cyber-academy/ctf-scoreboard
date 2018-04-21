# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  before_action :load_game, :load_message_count
  before_action :prevent_action_after_game, only: %i[new create]

  def new; end

  def create
    if verify_recaptcha
      super
    else
      build_resource(sign_up_params)
      clean_up_passwords(resource)
      set_flash_message! :alert, :recaptcha_failed
      render :new
    end
  end

  # DELETE /resource
  def destroy
    if resource.team_captain?
      set_flash_message! :alert, :captain_tried_to_destroy
      render 'edit'
    elsif params[:user] && resource.valid_password?(params[:user][:current_password])
      super
    else
      set_flash_message! :alert, :password_needed_destroy
      render 'edit'
    end
  end
end
