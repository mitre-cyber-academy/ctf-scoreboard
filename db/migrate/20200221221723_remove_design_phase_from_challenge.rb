class RemoveDesignPhaseFromChallenge < ActiveRecord::Migration[5.2]
  def change
    remove_column :flags, :design_phase
  end
end
