class AddTeamIdIndexToUser < ActiveRecord::Migration[4.2]
  def change
    add_index :users, :team_id
  end
end
