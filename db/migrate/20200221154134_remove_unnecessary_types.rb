class RemoveUnnecessaryTypes < ActiveRecord::Migration[5.2]
  def change
    remove_column :games, :type
    remove_column :divisions, :type
  end
end
