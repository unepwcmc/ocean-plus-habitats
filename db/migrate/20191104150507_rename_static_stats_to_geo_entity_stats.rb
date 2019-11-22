class RenameStaticStatsToGeoEntityStats < ActiveRecord::Migration[5.1]
  def change
    rename_table :static_stats, :geo_entity_stats
  end
end
