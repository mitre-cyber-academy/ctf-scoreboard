# frozen_string_literal: true

# Main controller for the application, handles redirects for the user login to the correct pages
# and sets devise parameters.
class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception
  before_action :set_mailer_host
  helper :all

  def user_root_path
    if @game&.open? && current_user&.on_a_team?
      game_summary_path
    elsif current_user&.on_a_team?
      team_path(current_user.team_id)
    else
      home_index_path
    end
  end

  def load_game
    @game = Game.instance
  end

  def load_message_count
    return if current_user.nil?
    @unread_message_count = @game.messages.where('updated_at >= :time', time: current_user.messages_stamp).count
  end

  def set_mailer_host
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  # Only allow access to information specific to the game when the game is actually open
  def filter_access_before_game_open
    return if current_user&.admin? || !@game.before_competition?
    redirect_to user_root_path, alert: I18n.t('game.not_available')
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
