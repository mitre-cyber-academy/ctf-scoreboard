class AddVerificationOfEntrollment < ActiveRecord::Migration[4.2]
  def change
    add_attachment :users, :verification
  end
end
