class AddTeamChallengeToFlag < ActiveRecord::Migration[5.2]
  def change
    add_reference :flags, :team, foreign_key: true
  end
end
