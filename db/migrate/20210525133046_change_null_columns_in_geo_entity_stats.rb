class ChangeNullColumnsInGeoEntityStats < ActiveRecord::Migration[5.1]
  def change
    change_column_null :geo_entity_stats, :protected_value, true
    change_column_null :geo_entity_stats, :total_value, true
    change_column_null :geo_entity_stats, :protected_percentage, true
  end
end
