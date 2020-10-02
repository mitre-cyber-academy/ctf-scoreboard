class AddLocationsToTeams < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :request_team_location, :boolean, default: false, null: false
    add_column :games, :location_required, :boolean, default: false, null: false
    add_column :teams, :team_location, :string, default: ''
  end
end
