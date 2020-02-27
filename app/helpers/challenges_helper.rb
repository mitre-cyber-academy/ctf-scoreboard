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

  def embed(youtube_url)
    youtube_id = youtube_url.split('v=').last
    content_tag(:iframe, nil, src: "https://www.youtube.com/embed/#{youtube_id}?rel=0", frameborder: 0)
  end

  def submit_url(team, challenge)
    return game_team_challenge_path(team, challenge.challenge_id) if challenge.is_a?(Flag)

    game_challenge_path(challenge)
  end

  def subheading(team, challenge)
    if team
      "#{team.team_name} - #{pluralize(challenge.point_value(current_user&.team), 'point')}"
    elsif challenge.respond_to?(:category)
      "#{challenge.category.name || "word"} - #{pluralize(challenge.point_value, 'point')}"
    else
      pluralize(challenge.point_value, 'point')
    end
  end

  def admin_edit_url(challenge)
    if challenge.is_a?(Flag)
      rails_admin.edit_path('pentest_challenge', challenge)
    else
      rails_admin.edit_path('point_challenge', challenge)
    end
  end
end
