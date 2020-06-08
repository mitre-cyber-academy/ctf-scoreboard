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
    tag.iframe(nil, src: "https://www.youtube.com/embed/#{youtube_id}?rel=0", frameborder: 0)
  end

  def submit_url(team, challenge)
    return game_team_challenge_path(team, challenge.challenge_id) if challenge.is_a?(Flag)

    game_challenge_path(challenge)
  end

  def subheading(team, challenge)
    point_value = pluralize(challenge.display_point_value(current_user&.team), 'point')
    team_or_category =  if team
                          team.team_name.to_s
                        elsif challenge.respond_to?(:categories)
                          challenge.category_list
                        end
    team_or_category + " - #{point_value}"
  end

  def admin_edit_url(challenge)
    rails_admin.edit_path(challenge.type.underscore, challenge)
  end
end
