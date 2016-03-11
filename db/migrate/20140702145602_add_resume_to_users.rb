class AddVerificationToUsers < ActiveRecord::Migration
  def change
    add_attachment :users, :Verification, :Resume
  end

  # def prevent_spoofing
  # 	add_attachment :avatar
  # 	add_attachment :avatar, :matches => [/pdf\Z/, /docx\Z/]
  # 	add_attachment :avatar
  # end
end
