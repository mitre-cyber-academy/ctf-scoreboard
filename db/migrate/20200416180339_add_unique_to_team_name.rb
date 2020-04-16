class AddUniqueToTeamName < ActiveRecord::Migration[5.2]
  def change
    add_index :teams, 'lower(team_name)', name: "index_teams_on_team_name_unique", unique: true
  end
end
