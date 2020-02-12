class AddTypeToSubmittedFlags < ActiveRecord::Migration[5.2]
  def change
    add_column :submitted_flags, :type, :string
  end
end
