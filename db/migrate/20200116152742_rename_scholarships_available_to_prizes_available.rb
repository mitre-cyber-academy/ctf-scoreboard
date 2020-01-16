class RenameScholarshipsAvailableToPrizesAvailable < ActiveRecord::Migration[5.2]
  def change
    rename_column :games, :scholarships_available, :prizes_available
  end
end
