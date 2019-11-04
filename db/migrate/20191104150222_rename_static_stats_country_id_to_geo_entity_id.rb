class RenameStaticStatsCountryIdToGeoEntityId < ActiveRecord::Migration[5.1]
  def change
    rename_column :static_stats, :country_id, :geo_entity_id
  end
end
