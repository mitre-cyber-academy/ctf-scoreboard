class RemoveTeamCaptainFromUsers < ActiveRecord::Migration
  def up
  	remove_column :users, :team_captain
  end

  def down
    add_column :users, :team_captain, :boolean
  end
end
