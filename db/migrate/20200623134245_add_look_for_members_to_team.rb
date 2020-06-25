class AddLookForMembersToTeam < ActiveRecord::Migration[6.0]
  def change
    add_column :teams, :look_for_member, :boolean, default: true, null: false
  end
end
