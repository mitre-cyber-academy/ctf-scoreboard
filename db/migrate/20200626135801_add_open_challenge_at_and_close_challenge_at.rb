class AddOpenChallengeAtAndCloseChallengeAt < ActiveRecord::Migration[6.0]
  def change
    add_column :challenges, :open_challenge_at, :datetime
    add_column :challenges, :close_challenge_at, :datetime
  end
end
