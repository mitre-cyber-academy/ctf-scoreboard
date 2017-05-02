class AddChallengeStateToChallenges < ActiveRecord::Migration[5.0]
  def change
    add_column :challenges, :state, :integer
  end
end
