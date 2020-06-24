class AddChallengeEndTime < ActiveRecord::Migration[6.0]
  def change
    add_column :challenges, :challenge_end, :datetime
  end
end
