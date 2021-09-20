class AddAgeRequirementAcceptedToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :age_requirement_accepted, :boolean, default: false
  end
end
