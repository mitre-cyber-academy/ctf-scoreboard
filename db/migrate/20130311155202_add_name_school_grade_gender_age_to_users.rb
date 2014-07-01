class AddNameSchoolGradeGenderAgeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :school, :string
    add_column :users, :grade, :integer, :limit => 2
    add_column :users, :gender, :string, :limit => 1
    add_column :users, :age, :integer, :limit => 2
  end
end
