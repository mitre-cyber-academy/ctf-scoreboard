class RemoveUsersCountFromTeams < ActiveRecord::Migration[5.2]
  def change
    remove_column :teams, :users_count
  end
end
