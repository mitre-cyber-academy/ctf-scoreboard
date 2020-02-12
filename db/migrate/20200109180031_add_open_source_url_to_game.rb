class AddOpenSourceUrlToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :open_source_url, :string
  end
end
