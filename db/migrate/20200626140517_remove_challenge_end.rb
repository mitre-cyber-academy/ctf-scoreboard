class RemoveChallengeEnd < ActiveRecord::Migration[6.0]
  def change
    remove_column :challenges, :challenge_end
  end
end
