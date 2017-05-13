class AddTimestampsToSubmittedFlags < ActiveRecord::Migration[5.0]
  def change
    add_timestamps :submitted_flags, default: DateTime.now
    change_column_default :submitted_flags, :created_at, nil
    change_column_default :submitted_flags, :updated_at, nil
  end
end
