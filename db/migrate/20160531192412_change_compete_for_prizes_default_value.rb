class ChangeCompeteForPrizesDefaultValue < ActiveRecord::Migration[4.2]
  def change
    change_column :users, :compete_for_prizes, :boolean, :default => false
  end
end
