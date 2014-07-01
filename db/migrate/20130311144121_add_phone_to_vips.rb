class AddPhoneToVips < ActiveRecord::Migration
  def change
	add_column :vips, :phone, :string
  end
end
