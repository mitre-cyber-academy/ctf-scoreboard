class AddManualApprovalToVips < ActiveRecord::Migration[4.2]
  def change
  	add_column :vips, :manual_approval, :boolean
  end
end
