class AddGameInfoToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :subtitle, :string
    add_column :games, :contact_url, :string
    add_column :games, :footer, :text
  end
end
