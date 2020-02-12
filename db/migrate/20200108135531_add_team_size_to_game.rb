class AddTeamSizeToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :team_size, :integer, default: 5
  end
end
