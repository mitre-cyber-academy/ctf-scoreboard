class AddCompeteForPrizesToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :compete_for_prizes, :boolean, :default => false
  end
end
