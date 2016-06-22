class AddVerificationOfEntrollment < ActiveRecord::Migration
  def change
    add_attachment :users, :verification
  end
end
