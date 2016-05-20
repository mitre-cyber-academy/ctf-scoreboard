class RenamePlayForMoneyToCompeteForPrizes < ActiveRecord::Migration
  def change
    rename_column :users, :play_for_money, :compete_for_prizes
  end
end
