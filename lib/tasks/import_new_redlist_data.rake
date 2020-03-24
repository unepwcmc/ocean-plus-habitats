require 'csv'

namespace :import do

  desc "import RedList species data into database"
  task :new_redlist_data, [:geo_type] => [:environment] do |t, args|
    if args[:geo_type].present?
      send("import_for_#{args[:geo_type]}")
    else
      import_for_countries
      import_for_regions
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

  def import_for_countries
    species_filename = "lib/data/iucn_redlist/country_species.csv".freeze
    prev_iso, prev_hab = nil, nil
    @failed_report = []

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

    log_failed('countries')
  end

  def import_for_regions
    species_filename = "lib/data/iucn_redlist/region_species.csv".freeze
    @failed_report = []

    CSV.foreach(species_filename, headers: true) do |row|
      habitat = Habitat.where('LOWER(title) = ?', row['habitat'].downcase).first
      next unless log_habitat(row, habitat)

      import_species(row, habitat)
      import_regions_species(row, habitat)
    end

    log_failed('regions')
  end

  def import_species(row, habitat)
    species_header = Species.new.attributes.keys.freeze
    scientific_name = row['scientific_name']

    return if scientific_name == 'NA'
    return if Species.find_by(scientific_name: scientific_name, habitat_id: habitat.id).present?

    row['url'] = 'https://'.concat(row['url']) if (row['url'] != 'N/A' && !row['url'].match(/^https/))
    row_hash = row.to_hash.slice(*species_header)
    species = Species.new(row_hash.merge(habitat_id: habitat.id))
    report_failed(row, species.errors.messages) unless species.save
  end

  def import_countries_species(row, habitat)
    iso3 = row['iso3']

    geo_entity = GeoEntity.find_by(iso3: iso3)
    if geo_entity.blank? && !iso3.downcase == 'global'
      report_failed(row, "GeoEntity not found!")
      return
    end

    scientific_name = row['scientific_name']
    species = Species.find_by(scientific_name: scientific_name, habitat_id: habitat.id)
    unless species.present?
      report_failed(row, "Species, habitat pair not found!")
      return
    end

    geo_entity = GeoEntity.find_or_create_by(iso3: 'GBL', name: 'Global') if iso3.downcase == 'global'
    create_geo_entities_species(row, species, geo_entity)
  end


  def import_regions_species(row, habitat)
    region = row['region']

    geo_entity = GeoEntity.find_by(iso3: nil, name: region)
    if geo_entity.blank?
      report_failed(row, "GeoEntity not found!")
      return
    end

    scientific_name = row['scientific_name']
    species = Species.find_by(scientific_name: scientific_name, habitat_id: habitat.id)
    unless species.present?
      report_failed(row, "Species, habitat pair not found!")
      return
    end

    create_geo_entities_species(row, species, geo_entity)
  end

  def create_geo_entities_species(row, species, geo_entity)
    ges = GeoEntitiesSpecies.find_or_initialize_by(species_id: species.id, geo_entity_id: geo_entity.id)
    report_failed(row, "Species, GeoEntity pair already existing!") if ges.id
    report_failed(row, ges.errors.messages) unless ges.save
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
      error = "Habitat #{row['habitat']} not found!"
      @failed_report << row.push(error)
      return false
    end
    true
  end

  def report_failed(row, error)
    @failed_report << row.headers.map(&:to_s).push('error') if @failed_report.empty?
    @failed_report << row.values_at(*row.headers).push(error)
  end

  def log_failed(geo_type)
    if @failed_report.present?
      filename = "tmp/failed_report_#{geo_type}.csv"
      p "A report with rows which failed to import has been generated here: #{filename}"
      CSV.open(filename, 'w') do |csv|
        @failed_report.each { |row| csv << row }
      end
    end
  end
end
