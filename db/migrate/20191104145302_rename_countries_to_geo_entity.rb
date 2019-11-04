class RenameCountriesToGeoEntity < ActiveRecord::Migration[5.1]
  def change
    rename_table :countries, :geo_entities
  end
end
