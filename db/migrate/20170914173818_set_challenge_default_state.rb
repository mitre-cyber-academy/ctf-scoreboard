class SetChallengeDefaultState < ActiveRecord::Migration[5.0]
  def change
    change_column :challenges, :state, :integer, :default => 0, :null => false
  end
end
