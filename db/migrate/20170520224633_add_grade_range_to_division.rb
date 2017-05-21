class AddGradeRangeToDivision < ActiveRecord::Migration[5.0]
  def change
    add_column :divisions, :min_year_in_school, :integer, default: 0
    add_column :divisions, :max_year_in_school, :integer, default: 16
  end
end
