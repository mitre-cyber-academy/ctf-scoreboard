class AddTypeToFeedItems < ActiveRecord::Migration[5.0]
  def change
    add_column :feed_items, :type, :string
  end
end
