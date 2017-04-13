class AddTeamIdToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :team_id, :integer
  end
end
