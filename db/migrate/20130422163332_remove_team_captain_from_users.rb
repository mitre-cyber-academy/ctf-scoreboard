class RemoveTeamCaptainFromUsers < ActiveRecord::Migration[4.2]
  def up
  	remove_column :users, :team_captain
  end

  def down
    add_column :users, :team_captain, :boolean
  end
end
