class AddIndexToFlags < ActiveRecord::Migration[5.2]
  def change
    add_index :flags, :design_phase_flag, where: true
  end
end
