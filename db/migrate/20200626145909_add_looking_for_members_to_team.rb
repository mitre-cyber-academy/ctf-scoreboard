class AddLookingForMembersToTeam < ActiveRecord::Migration[6.0]
  def change
    add_column :teams, :looking_for_members, :boolean, default: true, null: false
  end
end
