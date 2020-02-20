class AddDesignPhaseChallengeToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :design_phase_challenge, :boolean, default: false
  end
end
