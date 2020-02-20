# frozen_string_literal: true

class Achievement < FeedItem
  validates :text, presence: true, uniqueness: true
end
