class Species < ApplicationRecord
  has_many :geo_entities_species, class_name: 'GeoEntitiesSpecies', primary_key: 'species_id'
  has_many :geo_entities, through: :geo_entities_species
  belongs_to :habitat

  THREATENED = ['CR', 'EN', 'VU'].freeze
  NEAR_THREATENED = 'NT'.freeze
  # most common is to be determined in a meeting
  # most threatened is to be ordered as follows;
  #
  # Critically Endangered, Endangered, Vulnerable
  # CR is the most endangered, then comes EN, third VU
  # and if there are not 3 species of these categories, NT (near threatened)
  # could also be considered.

  # Example output:
  # => ["Tabebuia palustris", nil, "VU", "Pelliciera rhizophoreae", nil, "VU", "Avicennia bicolor", nil, "VU"]

  scope :threatened, -> { where(redlist_status: THREATENED) }
  scope :near_threatened, -> { where(redlist_status: NEAR_THREATENED) }
  scope :threatened_and_near, -> { where(redlist_status: [THREATENED, NEAR_THREATENED].flatten) }
  scope :not_threatened, -> { where.not(redlist_status: THREATENED) }
end
