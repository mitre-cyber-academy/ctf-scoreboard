class AddEmploymentOpportunitiesAvailableToGame < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :employment_opportunities_available, :boolean, default: false
  end
end
