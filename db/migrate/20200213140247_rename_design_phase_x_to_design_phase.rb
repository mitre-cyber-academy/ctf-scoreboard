class RenameDesignPhaseXToDesignPhase < ActiveRecord::Migration[5.2]
  def change
    rename_column :challenges, :design_phase_challenge, :design_phase
    rename_column :flags, :design_phase_flag, :design_phase
  end
end
