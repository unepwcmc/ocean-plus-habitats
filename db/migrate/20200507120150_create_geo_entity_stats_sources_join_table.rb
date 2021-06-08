class CreateGeoEntityStatsSourcesJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_table :geo_entity_stats_sources do |t|
      t.integer :geo_entity_stat_id
      t.integer :citation_id

      t.timestamps
    end

    add_index :geo_entity_stats_sources, [:geo_entity_stat_id, :citation_id], unique: true, name: 'index_geo_entity_stat_source'
  end
end
