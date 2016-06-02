class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception
  before_filter :set_mailer_host
  helper :all

  def user_root_path
    if current_user.on_a_team?
      team_path(current_user.team_id)
    else
      join_team_users_path
    end
  end

  def set_mailer_host
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  private

  def configure_permitted_parameters # Be sure to update this in the confirmations controller as well if you need to add parameters.
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :affiliation, :year_in_school, :state, :compete_for_prizes, :gender, :age, :area_of_study])
    devise_parameter_sanitizer.permit(:account_update, keys: [:full_name, :affiliation, :year_in_school, :state, :compete_for_prizes, :gender, :age, :area_of_study])
  end
end
