class RenameChallengesSolveShares < ActiveRecord::Migration[5.2]
  def change
    rename_column :challenges, :solve_share_decrement, :solved_decrement_shares
    add_column :challenges, :solved_decrement_period, :integer, default: 1
  end
end
