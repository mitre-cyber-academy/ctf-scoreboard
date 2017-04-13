class ChangeDataTypeForGender < ActiveRecord::Migration[4.2]
  def change
    change_column :users, :gender,  :integer
  end
end
