class AddTeamCaptainIdToTeam < ActiveRecord::Migration[4.2]
  def change
    add_column :teams, :team_captain_id, :integer
  end
end
