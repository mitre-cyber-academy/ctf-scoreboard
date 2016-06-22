class AddStatusToUserRequests < ActiveRecord::Migration
  def change
    add_column :user_requests, :status, :integer, null: false, default: 0
  end
end
