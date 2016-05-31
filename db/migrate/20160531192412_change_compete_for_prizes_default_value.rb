class ChangeCompeteForPrizesDefaultValue < ActiveRecord::Migration
  def change
    change_column :users, :compete_for_prizes, :boolean, :default => false
  end
end
