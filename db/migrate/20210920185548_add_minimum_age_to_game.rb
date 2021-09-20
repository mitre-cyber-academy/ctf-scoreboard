class AddMinimumAgeToGame < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :minimum_age, :integer, default: 16
  end
end
