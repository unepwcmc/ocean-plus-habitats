require 'csv'

namespace :import do
  desc "import RedList species data into database"
  task :redlist_data => [:environment] do
    HABITATS = %w(mangroves seagrasses coralreefs coldcorals).freeze

    HABITATS.each do |habitat|
      habitat_obj = Habitat.find_by(name: habitat)

      unless habitat_obj.present?
        p "Habitat #{habitat} not found!"
        next
      end

      p "=====PROCESSING #{habitat}====="

      import_species(habitat_obj)
      import_countries_species(habitat_obj)
    end
  end

  def import_species(habitat)
    species_header = Species.new.attributes.keys.freeze
    species_filename = "#{Rails.root}/lib/data/species/#{habitat.name}/species-utf8.csv".freeze

    CSV.foreach(species_filename, headers: true) do |row|
      # TODO Remove empty rows from CSVs
      next unless row['species_id']
      next if Species.find_by(species_id: row['species_id']).present?
      row_hash = row.to_hash.slice(*species_header)
      Species.create(row_hash.merge(habitat_id: habitat.id))
    end
  end

  def import_countries_species(habitat)
    countries_species_filename = "#{Rails.root}/lib/data/species/#{habitat.name}/country_species_join-utf8.csv".freeze

    CSV.foreach(countries_species_filename, headers: true) do |row|
      geo_entity = GeoEntity.find_by(iso3: row['iso3'])
      next unless geo_entity.present?
      GeoEntitiesSpecies.create(species_id: row['species_id'], geo_entity_id: geo_entity.id)
    end
  end
end
