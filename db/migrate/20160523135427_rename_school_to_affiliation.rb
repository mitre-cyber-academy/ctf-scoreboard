class RenameSchoolToAffiliation < ActiveRecord::Migration
  def change
    rename_column :users, :school, :affiliation
  end
end
