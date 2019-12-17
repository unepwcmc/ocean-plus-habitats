class AddOccurrenceToGeoEntityStat < ActiveRecord::Migration[5.1]
  def change
    add_column :geo_entity_stats, :occurrence, :integer, limit: 1
  end
end
