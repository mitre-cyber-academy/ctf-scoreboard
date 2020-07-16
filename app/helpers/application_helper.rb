# frozen_string_literal: true

module ApplicationHelper
  # Evaluate the condition, to show the link to a regular user, but always show the link
  # to an admin
  def always_link_to_if_admin(condition, p_name, options = {}, html_options = {}, &block)
    link_to_if((current_user&.admin? || condition), p_name, options, html_options, &block)
  end

  def view_time_format(time)
    time.strftime('%B %e at %l:%M %p %Z')
  end

  def greeting_for_dropdown(current_user)
    I18n.t('application.navbar.greeting') + (truncate(current_user.full_name, length: 30) || 'Admin')
  end

  def organization_for_navbar(game)
    game&.organization || I18n.t('application.game_name_if_organization_not_set')
  end

  def unread_messages(num_unread)
    num_unread unless num_unread&.eql? 0
  end

  def active_navbar?(page)
    'active' if current_page? page
  end

  def amount_of_errors(alerts)
    pluralize(alerts.length, I18n.t('challenges.error_singular')) + ':'
  end
end
