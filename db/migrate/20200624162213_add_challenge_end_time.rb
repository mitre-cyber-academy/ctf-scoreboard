class AddChallengeEndTime < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :datetime, :datetime
  end
end
