class AddVerificationToUsers < ActiveRecord::Migration
  def change
    add_attachment :users, :Verification, :Resume
  end
end
