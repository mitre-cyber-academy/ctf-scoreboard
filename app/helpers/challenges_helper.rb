# frozen_string_literal: true

module ChallengesHelper
  def wrong_flag_messages
    [
      'Really? Is that all you got?',
      "You can't be serious",
      'Incorrect flag',
      'Try again.',
      'lulz',
      'Yeah...no',
      "This is not the flag you're looking for *waves hand*",
      "Ok now you're just guessing."
    ]
  end

  def category_ids_to_names(category_ids, categories)
    category_names(categories.select { |category| category_ids.include?(category.id) })
  end

  # Takes a list of categories and returns all their names as a comma separated string,
  # or 'No Category' for an empty list
  def category_names(categories)
    return t('challenges.no_category') if categories.empty?

    categories.map(&:name).join(', ')
  end

  def embed(youtube_url)
    youtube_id = youtube_url.split('v=').last
    content_tag(:iframe, nil, src: "https://www.youtube.com/embed/#{youtube_id}?rel=0", frameborder: 0)
  end

  def submit_url(team, challenge)
    return game_team_challenge_path(team, challenge.challenge_id) if challenge.is_a?(Flag)

    game_challenge_path(challenge)
  end

  def subheading(team, challenge)
    point_value = pluralize(challenge.point_value(current_user&.team), 'point')
    if team
      "#{team.team_name} - #{point_value}"
    elsif challenge.respond_to?(:categories)
      "#{category_names(challenge.categories)} - #{point_value}"
    else
      point_value
    end
  end

  def admin_edit_url(challenge)
    if challenge.is_a?(Flag)
      rails_admin.edit_path('pentest_challenge', challenge)
    else
      rails_admin.edit_path('standard_challenge', challenge)
    end
  end
end
