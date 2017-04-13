class DropProductsTable < ActiveRecord::Migration[4.2]
  def up
    drop_table :teams
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
