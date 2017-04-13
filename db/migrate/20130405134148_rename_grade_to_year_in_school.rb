class RenameGradeToYearInSchool < ActiveRecord::Migration[4.2]
	def change
		rename_column :users, :grade, :year_in_school
	end
end
