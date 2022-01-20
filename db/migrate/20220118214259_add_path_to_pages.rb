class AddPathToPages < ActiveRecord::Migration[6.1]
  def change
    add_column :pages, :path, :string
  end
end
