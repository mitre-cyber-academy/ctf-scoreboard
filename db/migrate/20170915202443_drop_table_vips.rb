class DropTableVips < ActiveRecord::Migration[5.0]
  def change
    drop_table :vips
  end
end
