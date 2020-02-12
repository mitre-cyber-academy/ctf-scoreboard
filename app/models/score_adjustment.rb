# frozen_string_literal: true

class ScoreAdjustment < FeedItem
  include ActionView::Helpers::TextHelper

  validates :point_value, :text, presence: true
  validate :point_value_is_not_zero
  def description
    color, verb = if point_value.negative?
                    %w[red decreased]
                  else
                    %w[green increased]
                  end
    %(Score was #{verb} by <span style="color:#{color};">#{pluralize(point_value.abs, 'point')}</span>)
  end

  def icon
    point_value.negative? ? super('chevron-down') : super('chevron-up')
  end

  def point_value_is_not_zero
    errors.add(:point_value, 'must not be zero.') if point_value.zero?
  end
end
