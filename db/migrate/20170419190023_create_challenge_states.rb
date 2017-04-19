class CreateChallengeStates < ActiveRecord::Migration[5.0]
  def change
    create_table :challenge_states do |t|
      t.integer :state
      t.integer :challenge_id
      t.integer :division_id
    end
  end
end
