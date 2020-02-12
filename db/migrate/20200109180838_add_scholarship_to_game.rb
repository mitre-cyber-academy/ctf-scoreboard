class AddScholarshipToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :scholarships_available, :boolean, default: false
  end
end
