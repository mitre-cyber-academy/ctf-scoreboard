class AddUniqueIndexToGameIdAndPath < ActiveRecord::Migration[6.1]
  def change
    add_index :pages, [:game_id, :path], unique: true
  end
end
