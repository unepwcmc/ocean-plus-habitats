class GeoEntity < ApplicationRecord
  has_many :geo_entities_species, class_name: 'GeoEntitiesSpecies'
  has_many :species, through: :geo_entities_species
  has_one :geo_entity_stat
  # At the moment, only mangroves have got change stats,
  # which means there can only be one change_stat record per country.
  # This can change in the future
  has_one :change_stat

  scope :countries, -> { where.not(iso3: nil) }
  scope :regions, -> { where(iso3: nil) }


  # most common is to be determined in a meeting
  # most threatened is to be ordered as follows;
  #
  # Critically Endangered, Endangered, Vulnerable
  # CR is the most endangered, then comes EN, third VU
  # and if there are not 3 species of these categories, NT (near threatened)
  # could also be considered.

  # Example output:
  # => ["Tabebuia palustris", nil, "VU", "Pelliciera rhizophoreae", nil, "VU", "Avicennia bicolor", nil, "VU"]

  def get_species_images(habitat, type)
    habitat_species = species.where(habitat_id: habitat.id, redlist_status: ["CR", "EN", "VU"])
    habitat_species_nt = species.where(habitat_id: habitat.id, redlist_status: ["NT"])
    return nil if iso3.nil? || habitat.nil?
    if type == :most_common
      return 0
    elsif type == :most_threatened
      hs = habitat_species.order(redlist_status: :asc).pluck(:scientific_name, :common_name, :redlist_status)
      hs << habitat_species_nt.pluck(:scientific_name, :common_name, :redlist_status)
      hs.flatten
    end
  end
end
