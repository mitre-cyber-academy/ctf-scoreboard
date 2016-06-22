class RenameNameToFullName < ActiveRecord::Migration
  def change
    rename_column :users, :name, :full_name
  end
end
