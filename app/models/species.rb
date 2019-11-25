class Species < ApplicationRecord
  has_many :geo_entities_species, class_name: 'GeoEntitiesSpecies', primary_key: 'species_id'
  has_many :geo_entities, through: :geo_entities_species

    # most common is to be determined in a meeting
  # most threatened is to be ordered as follows;
  #
  # Critically Endangered, Endangered, Vulnerable
  # CR is the most endangered, then comes EN, third VU
  # and if there are not 3 species of these categories, NT (near threatened)
  # could also be considered.

  # Example output:
  # => ["Tabebuia palustris", nil, "VU", "Pelliciera rhizophoreae", nil, "VU", "Avicennia bicolor", nil, "VU"]

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
    "Pelliciera rhizophorae",
    "Tabebuia Ruppia maritima",
    "Ruppia filifolia",
    "Ruppia cirrhosa",
    "Ruppia megacarpa",
    "Ruppia tuberosapalustris"].freeze

  def self.get_species_without_image_data
    NO_IMAGE_DATA
  end
end
