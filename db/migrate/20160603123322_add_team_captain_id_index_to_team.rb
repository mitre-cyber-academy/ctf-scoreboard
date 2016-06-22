class AddTeamCaptainIdIndexToTeam < ActiveRecord::Migration
  def change
    add_index :teams, :team_captain_id
  end
end
