class AddAffiliationToTeam < ActiveRecord::Migration[4.2]
  def change
    add_column :teams, :affiliation, :string
  end
end
