class DropTable < ActiveRecord::Migration[4.2]
   def up
    drop_table :vips
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
