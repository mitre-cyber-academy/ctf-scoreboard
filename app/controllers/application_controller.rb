# frozen_string_literal: true

# Main controller for the application, handles redirects for the user login to the correct pages
# and sets devise parameters.
class ApplicationController < ActionController::Base
  include SessionsHelper

  protect_from_forgery with: :exception

  before_action :set_paper_trail_whodunnit
  before_action :configure_permitted_parameters, if: :devise_controller?
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

    redirect_to user_root_path, alert: I18n.t('game.before_competition')
  end

  def deny_team_in_top_ten
    return if @game.before_competition? || !@team&.in_top_ten?

    redirect_back fallback_location: user_root_path, alert: I18n.t('teams.in_top_ten')
  end

  def deny_if_not_admin
    return if current_user&.admin?

    raise ActiveRecord::RecordNotFound
  end

  def prevent_action_after_game
    return unless @game.after_competition?

    redirect_back fallback_location: user_root_path, alert: I18n.t('game.after_competition')
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: User.user_editable_keys
    )
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: User.user_editable_keys
    )
  end

  def enforce_access
    deny_access unless current_user
  end
end
