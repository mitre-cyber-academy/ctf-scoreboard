class RemoveDesignPhaseChallengeFlag < ActiveRecord::Migration[6.0]
  def change
    remove_column :challenges, :design_phase
    remove_column :flags, :design_phase
  end
end
