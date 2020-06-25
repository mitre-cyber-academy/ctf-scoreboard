class ChangeLookForMemberToTeam < ActiveRecord::Migration[6.0]
  def change
    change_column :teams, :look_for_member, :boolean, :default => true, :null => true
  end
end
