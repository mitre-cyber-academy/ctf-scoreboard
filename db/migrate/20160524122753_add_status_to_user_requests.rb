class AddStatusToUserRequests < ActiveRecord::Migration[4.2]
  def change
    add_column :user_requests, :status, :integer, null: false, default: 0
  end
end
