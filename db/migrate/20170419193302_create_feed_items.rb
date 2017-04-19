class CreateFeedItems < ActiveRecord::Migration[5.0]
  def change
    create_table :feed_items do |t|
      t.integer :user_id
      t.integer :team_id
      t.integer :division_id
      t.string :text
      t.integer :challenge_id
      t.integer :point_value
      t.integer :flag_id
    end
  end
end
