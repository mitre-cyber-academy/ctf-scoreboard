class AddTimestampsToFeedItems < ActiveRecord::Migration[5.0]
  def change
    add_timestamps :feed_items, default: DateTime.now
    change_column_default :feed_items, :created_at, nil
    change_column_default :feed_items, :updated_at, nil
  end
end
