class AddSuccessTextToFlags < ActiveRecord::Migration[6.0]
  def change
    add_column :flags, :success_text, :text
  end
end
