require 'csv'

namespace :import do
  HABITATS = %w(mangroves seagrasses coralreefs coldcorals).freeze

  desc "import RedList species data into database"
  task :redlist_data => [:environment] do

    HABITATS.each do |habitat|
      habitat_obj = Habitat.find_by(name: habitat)

      next unless log_habitat(habitat_obj)

      import_species(habitat_obj)
      import_countries_species(habitat_obj)
      import_occurrences(habitat_obj)
    end
  end

  desc "import habitats occurrences"
  task :occurrences => [:environment] do
    HABITATS.each do |habitat|
      habitat_obj = Habitat.find_by(name: habitat)

      next unless log_habitat(habitat_obj)

      import_occurrences(habitat_obj)
    end
  end

  def import_species(habitat)
    species_header = Species.new.attributes.keys.freeze
    species_filename = "lib/data/species/#{habitat.name}/species-utf8.csv".freeze

    CSV.foreach(species_filename, headers: true) do |row|
      next unless row['species_id']
      next if Species.find_by(species_id: row['species_id'], habitat_id: habitat.id).present?
      row['url'] = 'https://'.concat(row['url']) if (row['url'] != 'N/A' && !row['url'].match(/^https/))
      row_hash = row.to_hash.slice(*species_header)
      Species.create(row_hash.merge(habitat_id: habitat.id))
    end
  end

  def import_countries_species(habitat)
    countries_species_filename = "lib/data/species/#{habitat.name}/country_species_join-utf8.csv".freeze

    CSV.foreach(countries_species_filename, headers: true) do |row|
      geo_entity = GeoEntity.find_by(iso3: row['iso3'])
      next unless geo_entity.present?
      species = Species.find_by(species_id: row['species_id'], habitat_id: habitat.id)
      next unless species.present?
      GeoEntitiesSpecies.find_or_create_by(species_id: species.id, geo_entity_id: geo_entity.id)
    end
  end

  # 0 = confirmed absence
  # 1 = unknown
  # 2 = confirmed presence
  def import_occurrences(habitat)
    countries_list_filename = "lib/data/species/#{habitat.name}/countrylist-utf8.csv".freeze
    CSV.foreach(countries_list_filename, headers: true) do |row|
      geo_entity = GeoEntity.find_by(iso3: row['iso3'])
      occurrence = row['occurrence'].to_i
      next unless geo_entity.present?
      GeoEntityStat.find_or_initialize_by(geo_entity_id: geo_entity.id, habitat_id: habitat.id).
        update_attributes!(occurrence: occurrence)
    end
  end

  def log_habitat(habitat)
    unless habitat.present?
      p "Habitat #{habitat.name} not found!"
      return false
    end

    p "=====PROCESSING #{habitat.name}====="
    true
  end
end
