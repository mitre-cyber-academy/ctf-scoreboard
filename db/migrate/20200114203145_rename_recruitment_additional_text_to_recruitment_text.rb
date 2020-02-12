class RenameRecruitmentAdditionalTextToRecruitmentText < ActiveRecord::Migration[5.2]
  def change
    rename_column :games, :recruitment_additional_text, :recruitment_text
  end
end
