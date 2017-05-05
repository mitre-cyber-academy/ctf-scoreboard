class RemoveAdminsTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :admins
  end
end
