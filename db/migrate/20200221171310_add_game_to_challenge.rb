class AddGameToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_reference :challenges, :game, foreign_key: true
  end
end
