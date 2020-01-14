# frozen_string_literal: true

class Achievement < FeedItem
  validates :text, presence: true, uniqueness: true

  def description
    %(Unlocked #{super} "#{text}")
  end

  def icon
    super('certificate')
  end
end
