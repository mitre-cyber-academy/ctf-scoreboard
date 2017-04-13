class AddTeamCaptainIdIndexToTeam < ActiveRecord::Migration[4.2]
  def change
    add_index :teams, :team_captain_id
  end
end
