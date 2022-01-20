class ChangeColumnNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :pages, :path, false
  end
end
