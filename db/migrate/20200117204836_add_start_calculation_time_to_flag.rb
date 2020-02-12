class AddStartCalculationTimeToFlag < ActiveRecord::Migration[5.2]
  def change
    add_column :flags, :start_calculation_at, :datetime
  end
end
