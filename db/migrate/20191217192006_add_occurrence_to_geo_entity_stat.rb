class AddOccurrenceToGeoEntityStat < ActiveRecord::Migration[5.1]
  def change
    # limit 1 is about limiting the integer size to 1 byte
    # as we don't need more than that many possibilities
    add_column :geo_entity_stats, :occurrence, :integer, limit: 1, default: 1
  end
end
