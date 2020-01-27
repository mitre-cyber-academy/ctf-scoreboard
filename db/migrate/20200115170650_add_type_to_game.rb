class AddTypeToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :type, :string
  end
end
