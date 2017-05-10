class AddDefaultEligibleToTeams < ActiveRecord::Migration[5.0]
  def change
    change_column_default :teams, :eligible, false
  end
end
