class ChangeStateLimitLengthOnUsers < ActiveRecord::Migration
  def change
    change_column :users, :state, :string, :limit => 2
  end
end
