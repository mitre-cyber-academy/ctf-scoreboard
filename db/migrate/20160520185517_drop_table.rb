class DropTable < ActiveRecord::Migration
   def up
    drop_table :vips
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
