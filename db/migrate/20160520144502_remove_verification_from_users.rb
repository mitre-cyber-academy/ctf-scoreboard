class RemoveVerificationFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_attachment :users, :verification
  end
end
