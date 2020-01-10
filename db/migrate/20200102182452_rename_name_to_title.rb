class RenameNameToTitle < ActiveRecord::Migration[5.2]
  def change
    rename_column :games, :name, :title
  end
end
