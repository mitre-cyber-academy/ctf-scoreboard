class AddChallengeStateToFlag < ActiveRecord::Migration[5.2]
  def change
    add_column :flags, :challenge_state, :integer, default: 0, null: false
  end
end
