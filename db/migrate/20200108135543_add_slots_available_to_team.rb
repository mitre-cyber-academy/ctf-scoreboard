class AddSlotsAvailableToTeam < ActiveRecord::Migration[5.2]
  def change
    add_column :teams, :slots_available, :integer, default: 0
  end
end
