class RemovePendingFromUserRequests < ActiveRecord::Migration[4.2]
  def change
    remove_column :user_requests, :pending
  end
end
