class AddManualApprovalToVips < ActiveRecord::Migration
  def change
  	add_column :vips, :manual_approval, :boolean
  end
end
