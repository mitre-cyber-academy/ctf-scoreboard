class AddCompeteForPrizesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :compete_for_prizes, :boolean, :default => false
  end
end
