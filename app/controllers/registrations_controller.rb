# frozen_string_literal: true
class RegistrationsController < Devise::RegistrationsController
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
