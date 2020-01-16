class DropRecruitmentUrlFromGames < ActiveRecord::Migration[5.2]
  def change
    remove_column :games, :participant_recruitment_url
  end
end
