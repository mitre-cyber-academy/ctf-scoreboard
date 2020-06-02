class AddBoardLayoutToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :board_layout, :integer, default: 0, null: false
  end
end
