class RenameManualApprovalToManuallyApproved < ActiveRecord::Migration[4.2]
  def up
  	rename_column :vips, :manual_approval, :manually_approved
  end

  def down
  	rename_column :vips, :manually_approved, :manual_approval
  end
end
