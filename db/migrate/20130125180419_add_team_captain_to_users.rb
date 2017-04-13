class AddTeamCaptainToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :team_captain, :boolean
  end
end
