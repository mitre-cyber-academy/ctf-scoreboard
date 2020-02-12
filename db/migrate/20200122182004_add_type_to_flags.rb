class AddTypeToFlags < ActiveRecord::Migration[5.2]
  def change
    add_column :flags, :type, :string
  end
end
