class GeoEntity < ApplicationRecord
  has_many :geo_entities_species, class_name: 'GeoEntitiesSpecies'
  has_many :species, through: :geo_entities_species
  has_one :geo_entity_stat
  # At the moment, only mangroves have got change stats,
  # which means there can only be one change_stat record per country.
  # This can change in the future
  has_one :change_stat

  has_many :region_relationship, foreign_key: :country_id, class_name: 'GeoRelationship'
  has_many :regions, through: :region_relationship, class_name: 'GeoEntity'
  has_many :country_relationship, foreign_key: :region_id, class_name: 'GeoRelationship'
  has_many :countries, through: :country_relationship, class_name: 'GeoEntity'

  scope :countries, -> { where.not(iso3: nil) }
  scope :regions, -> { where(iso3: nil) }

  # Returns species data if directly attached to the GeoEntity, so a country.
  # Returns species data for all associated countries if it is a region
  def all_species
    return species if species.present?
    Species.joins(:geo_entities).where(geo_entities: { id: countries.map(&:id) })
  end

  # most common is to be determined in a meeting
  # most threatened is to be ordered as follows;
  #
  # Critically Endangered, Endangered, Vulnerable
  # CR is the most endangered, then comes EN, third VU
  # and if there are not 3 species of these categories, NT (near threatened)
  # could also be considered.

  # Example output:
  # => ["Tabebuia palustris", nil, "VU", "Pelliciera rhizophoreae", nil, "VU", "Avicennia bicolor", nil, "VU"]
end
