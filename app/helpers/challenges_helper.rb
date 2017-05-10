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
    content_tag(:iframe, nil, src: "//www.youtube.com/embed/#{youtube_id}", frameborder: 0)
  end
end
