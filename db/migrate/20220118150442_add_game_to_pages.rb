class AddGameToPages < ActiveRecord::Migration[6.1]
  def change
    add_reference :pages, :game, null: false, foreign_key: true
  end
end
