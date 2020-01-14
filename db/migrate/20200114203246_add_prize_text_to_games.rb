class AddPrizeTextToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :prizes_text, :text
  end
end
