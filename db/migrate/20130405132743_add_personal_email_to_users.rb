class AddPersonalEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :personal_email, :string
  end
end
