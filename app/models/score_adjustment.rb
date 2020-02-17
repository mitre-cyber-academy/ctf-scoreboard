# frozen_string_literal: true

class ScoreAdjustment < FeedItem
  with_options presence: true do
    validates :text
    validates :point_value, numericality: { other_than: 0 }
  end
end
