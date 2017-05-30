# frozen_string_literal: true

# Main controller for the application, handles redirects for the user login to the correct pages
# and sets devise parameters.
class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception
  before_action :set_mailer_host
  helper :all

  # TODO: if game started and user on a team show scoreboard home
  def user_root_path
    if current_user.on_a_team?
      team_path(current_user.team_id)
    else
      home_index_path
    end
  end

  def load_game
    @game = Game.instance
  end

  def set_mailer_host
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  private

  def configure_permitted_parameters
    # Be sure to update this in the confirmations controller as well if you need to add parameters.
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: %i[full_name affiliation year_in_school state compete_for_prizes gender age area_of_study]
    )
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: %i[full_name affiliation year_in_school state compete_for_prizes gender age area_of_study]
    )
  end

  def enforce_access
    deny_access unless current_user
  end
end
