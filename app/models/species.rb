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

  NO_IMAGE_DATA = [
    "Acrostichum danaeifolium",
    "Avicennia integra",
    "Avicennia rumphiana",
    "Ceriops australis",
    "Diospyros littorea",
    "Dolichandrone spathacea",
    "Kandelia obovata",
    "Rhizophora samoensis",
    "Sonneratia lanceolata",
    "Avicennia bicolor",
    "Avicennia schaueriana",
    "Mora oleifera",
    "Pelliciera rhizophoreae",
    "Tabebuia palustris",
    "Tabebuia Ruppia maritima",
    "Ruppia filifolia",
    "Ruppia cirrhosa",
    "Ruppia megacarpa",
    "Ruppia tuberosapalustris"
  ].freeze

  def self.get_species_without_image_data
    NO_IMAGE_DATA
  end

  def generate_redlist_url
    iucn_genus = "bruguiera"
    iucn_species = "cylindrica"

    "https://apiv3.iucnredlist.org/api/v3/website/#{iucn_genus}%20#{iucn_species}"
  end
end
