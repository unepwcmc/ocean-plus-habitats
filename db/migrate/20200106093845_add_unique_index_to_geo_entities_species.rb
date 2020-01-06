class AddUniqueIndexToGeoEntitiesSpecies < ActiveRecord::Migration[5.1]
  def change
    add_index :geo_entities_species, [:geo_entity_id, :species_id], unique: true
  end
end
