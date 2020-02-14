class ChangeDefaultChallengeInitialShares < ActiveRecord::Migration[5.2]
  def change
    change_column_default :challenges, :initial_shares, 1
  end
end
