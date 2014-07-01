class AddAffiliationToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :affiliation, :string
  end
end
