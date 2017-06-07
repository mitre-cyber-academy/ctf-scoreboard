class AddUsersCountToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :users_count, :integer, default: 0
  end
end
