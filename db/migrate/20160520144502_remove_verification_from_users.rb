class RemoveVerificationFromUsers < ActiveRecord::Migration
  def change
    remove_attachment :users, :verification
  end
end
