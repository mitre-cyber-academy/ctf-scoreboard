class AddRestrictTopTenTeamsToGame < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :restrict_top_ten_teams, :boolean, default: true
  end
end
