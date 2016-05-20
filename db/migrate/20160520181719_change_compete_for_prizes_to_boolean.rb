class ChangeCompeteForPrizesToBoolean < ActiveRecord::Migration
  def change
    change_column :users, :compete_for_prizes, :boolean
  end
end
