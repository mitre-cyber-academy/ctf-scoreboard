class RemoveOpenSourceUrlFromGame < ActiveRecord::Migration[6.0]
  def change
    remove_column :games, :open_source_url, :string 
  end
end
