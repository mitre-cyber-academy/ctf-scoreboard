class AddWhyAreYouAVipToVips < ActiveRecord::Migration[4.2]
  def change
  	add_column :vips, :why_are_you_a_vip, :text
  end
end
