class AddAreaOfStudyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :area_of_study, :string
  end
end
