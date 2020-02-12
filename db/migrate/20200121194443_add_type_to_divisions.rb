class AddTypeToDivisions < ActiveRecord::Migration[5.2]
  def change
    add_column :divisions, :type, :string
  end
end
