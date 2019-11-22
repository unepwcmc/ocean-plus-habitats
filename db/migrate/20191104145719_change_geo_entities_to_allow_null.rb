class ChangeGeoEntitiesToAllowNull < ActiveRecord::Migration[5.1]
  def change
    change_column_null :geo_entities, :iso2, true
    change_column_null :geo_entities, :iso3, true
  end
end
