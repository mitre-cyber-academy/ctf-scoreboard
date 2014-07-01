class AddTeamCaptainToUsers < ActiveRecord::Migration
  def change
    add_column :users, :team_captain, :boolean
  end
end
