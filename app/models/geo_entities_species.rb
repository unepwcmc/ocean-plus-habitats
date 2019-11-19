class GeoEntitiesSpecies < ApplicationRecord
  belongs_to :species, primary_key: 'species_id'
  belongs_to :geo_entity
end
