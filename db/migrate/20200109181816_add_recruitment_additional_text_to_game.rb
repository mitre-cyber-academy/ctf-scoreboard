class AddRecruitmentAdditionalTextToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :recruitment_additional_text, :text
  end
end
