class RemoveChallengeStates < ActiveRecord::Migration[5.0]
  def change
    drop_table :challenge_states
  end
end
