class RenameSchoolToAffiliation < ActiveRecord::Migration[4.2]
  def change
    rename_column :users, :school, :affiliation
  end
end
