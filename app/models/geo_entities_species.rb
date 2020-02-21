class GeoEntitiesSpecies < ApplicationRecord
  belongs_to :species
  belongs_to :geo_entity

  validates :species, uniqueness: { scope: :geo_entity }
end
