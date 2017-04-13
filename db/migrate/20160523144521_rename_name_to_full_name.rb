class RenameNameToFullName < ActiveRecord::Migration[4.2]
  def change
    rename_column :users, :name, :full_name
  end
end
