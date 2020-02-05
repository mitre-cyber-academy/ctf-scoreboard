# frozen_string_literal: true

module ApplicationHelper
  # Evaluate the condition, to show the link to a regular user, but always show the link
  # to an admin
  def always_link_to_if_admin(condition, p_name, options = {}, html_options = {})
    link_to_if((current_user&.admin? || condition), p_name, options, html_options)
  end
end
