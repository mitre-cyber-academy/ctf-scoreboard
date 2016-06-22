class RemovePendingFromUserRequests < ActiveRecord::Migration
  def change
    remove_column :user_requests, :pending
  end
end
