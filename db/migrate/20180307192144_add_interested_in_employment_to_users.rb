class AddInterestedInEmploymentToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :interested_in_employment, :boolean, default: false
  end
end
