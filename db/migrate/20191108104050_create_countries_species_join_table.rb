class CreateCountriesSpeciesJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_table :geo_entities_species do |t|
      t.integer :geo_entity_id
      t.integer :species_id
    end

    add_index :geo_entities_species, :geo_entity_id
    add_index :geo_entities_species, :species_id
  end
end
