class Species < ApplicationRecord
  has_many :geo_entities_species, class_name: 'GeoEntitiesSpecies', primary_key: 'species_id'
  has_many :geo_entities, through: :geo_entities_species
end
