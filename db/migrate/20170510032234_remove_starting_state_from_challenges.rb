class RemoveStartingStateFromChallenges < ActiveRecord::Migration[5.0]
  def change
    remove_column :challenges, :starting_state
  end
end
