# frozen_string_literal: true

class Achievement < FeedItem
  validates :text, presence: true, uniqueness: true

  def description
    %(Unlocked achievement "#{text}")
  end

  def icon
    'certificate'
  end
end
