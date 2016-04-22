class RenameGradeToYearInSchool < ActiveRecord::Migration
	def change
		rename_column :users, :grade, :year_in_school
	end
end
