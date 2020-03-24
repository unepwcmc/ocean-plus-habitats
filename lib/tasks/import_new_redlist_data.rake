require 'csv'

namespace :import do

  desc "import RedList species data into database"
  task :new_redlist_data => [:environment] do

    species_filename = "lib/data/iucn_redlist/country_species.csv".freeze
    prev_iso, prev_hab = nil, nil

    CSV.foreach(species_filename, headers: true) do |row|

      habitat = Habitat.where('LOWER(title) = ?', row['habitat'].downcase).first
      next unless log_habitat(row, habitat)

      import_species(row, habitat)
      import_countries_species(row, habitat)

      current_iso, current_hab = row['iso3'], row['habitat']
      next if (current_iso == prev_iso) && (current_hab == prev_hab)
      import_occurrences(row, habitat)
      prev_iso, prev_hab = current_iso, current_hab
    end
  end

  desc "import habitats occurrences"
  task :occurrences => [:environment] do
    species_filename = "lib/data/iucn_redlist/country_species.csv".freeze

    CSV.read(species_filename, headers: true)
       .uniq { |r| r.values_at('iso3', 'habitat') }.each do |row|

      habitat = Habitat.where('LOWER(title) = ?', row['habitat'].downcase).first
      next unless log_habitat(row, habitat)

      import_occurrences(row, habitat)
    end
  end

  def import_species(row, habitat)
    species_header = Species.new.attributes.keys.freeze

    return if row['scientific_name'] == 'NA'
    return if Species.find_by(scientific_name: row['scientific_name'], habitat_id: habitat.id).present?
    row['url'] = 'https://'.concat(row['url']) if (row['url'] != 'N/A' && !row['url'].match(/^https/))
    row_hash = row.to_hash.slice(*species_header)
    Species.create(row_hash.merge(habitat_id: habitat.id))
  end

  def import_countries_species(row, habitat)
    geo_entity = GeoEntity.find_by(iso3: row['iso3'])
    return unless geo_entity.present?
    species = Species.find_by(scientific_name: row['scientific_name'], habitat_id: habitat.id)
    return unless species.present?
    GeoEntitiesSpecies.find_or_create_by(species_id: species.id, geo_entity_id: geo_entity.id)
  end

  # 0 = confirmed absence
  # 1 = unknown
  # 2 = confirmed presence
  def import_occurrences(row, habitat)
    geo_entity = GeoEntity.find_by(iso3: row['iso3'])
    return unless geo_entity.present?
    occurrence = row['occurence'].to_i
    GeoEntityStat.find_or_initialize_by(geo_entity_id: geo_entity.id, habitat_id: habitat.id)
                 .update_attributes!(occurrence: occurrence)
  end

  def log_habitat(row, habitat)
    unless habitat.present?
      p "Habitat #{row['habitat']} not found!"
      return false
    end
    true
  end
end
