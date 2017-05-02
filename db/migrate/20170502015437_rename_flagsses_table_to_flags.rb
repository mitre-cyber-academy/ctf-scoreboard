class RenameFlagssesTableToFlags < ActiveRecord::Migration[5.0]
  def change
    rename_table :flagsses, :flags
  end
end
