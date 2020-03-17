class AddCoastalPercentageToGeoEntityStat < ActiveRecord::Migration[5.1]
  def change
    add_column :geo_entity_stats, :coastal_coverage, :decimal
  end
end
