class AddConfirmedToVips < ActiveRecord::Migration
  def change
    add_column :vips, :confirmed, :boolean, :default => false
  end
end
