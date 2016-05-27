class AddStatusToUserInvites < ActiveRecord::Migration
  def change
    add_column :user_invites, :status, :integer, null: false, default: 0
  end
end
