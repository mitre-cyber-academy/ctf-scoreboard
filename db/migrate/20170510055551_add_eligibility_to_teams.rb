class AddEligibilityToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :eligible, :boolean
  end
end
