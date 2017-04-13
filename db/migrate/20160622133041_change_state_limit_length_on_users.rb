class ChangeStateLimitLengthOnUsers < ActiveRecord::Migration[4.2]
  def change
    change_column :users, :state, :string, :limit => 2
  end
end
