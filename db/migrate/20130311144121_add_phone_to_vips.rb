class AddPhoneToVips < ActiveRecord::Migration[4.2]
  def change
	add_column :vips, :phone, :string
  end
end
