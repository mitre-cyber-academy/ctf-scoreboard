class AddApplicationUrlToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :participant_recruitment_url, :string
  end
end
