class AddWhyAreYouAVipToVips < ActiveRecord::Migration
  def change
  	add_column :vips, :why_are_you_a_vip, :text
  end
end
