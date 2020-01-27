# frozen_string_literal: true

# Main controller for the application, handles redirects for the user login to the correct pages
# and sets devise parameters.
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :store_user_location, if: :storable_location?
  before_action :set_paper_trail_whodunnit
  before_action :configure_permitted_parameters, if: :devise_controller?
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

  def load_game(*preload_objects)
    if @game = Game.instance
      pl = ActiveRecord::Associations::Preloader.new
      preload_objects.filter! { |table| @game.respond_to?(table) }
      pl.preload(@game, preload_objects)
    else
      redirect_to(new_user_session_path, alert: I18n.t('game.must_be_admin')) && return unless current_user&.admin?
      redirect_to(rails_admin.new_path('game'), notice: I18n.t('game.setup', href: I18n.t('game.setup_href')))
    end
  end

  def load_message_count
    return if current_user.nil?

    @unread_message_count = @game.messages.where('updated_at >= :time', time: current_user.messages_stamp).count
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

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location
    store_location_for(:user, request.fullpath)
  end

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
    redirect_to new_user_session_path, notice: I18n.t('users.login_required') unless current_user
  end
end
