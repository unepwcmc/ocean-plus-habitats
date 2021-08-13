class AddGlobalHabitatCoverageProtectionStatsToHabitats < ActiveRecord::Migration[5.1]
  def change
    add_column :habitats, :total_area, :float, null: true
    add_column :habitats, :protected_area, :float, null: true
  end
end
