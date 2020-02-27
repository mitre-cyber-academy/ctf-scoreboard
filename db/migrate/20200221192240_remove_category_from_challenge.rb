class RemoveCategoryFromChallenge < ActiveRecord::Migration[5.2]
  def change
    remove_column :challenges, :category_id
  end
end
