class CreateFlags < ActiveRecord::Migration[5.0]
  def change
    create_table :flagsses do |t|
      t.integer :challenge_id
      t.string :flag
      t.string :api_url
      t.string :video_url
    end
  end
end
