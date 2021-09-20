class AddPrivacyNoticeToGame < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :privacy_notice, :text
  end
end
