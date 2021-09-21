class AddAgeRequirementAcceptedToUser < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :age_requirement_accepted, :boolean, default: false
    User.update_all(age_requirement_accepted: true)
  end

  def down
    remove_column :users, :age_requirement_accepted, :boolean, default: false
  end
end
