class AddTeamCaptainIdToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :team_captain_id, :integer
  end
end
