require 'csv'

namespace :import do
  desc "import countries data into database"
  task :countries => [:environment] do
    current_count = GeoEntity.countries.count
    Rails.logger.info("There are #{current_count} countries")
    CSV.foreach('lib/data/countries.csv', headers: true) do |row|
      name, iso2, iso3, bounding_box = [row['name'], row['alpha-2'], row['alpha-3'], row['bounding-box']]
      attributes = {
        name: name,
        iso2: iso2,
        iso3: iso3
      }
      # convert from string into array of arrays
      if bounding_box.present? && bounding_box.include?(';')
        bounding_box = bounding_box.split(';').map { |bb| bb.split(' ').map(&:to_f) }
        GeoEntity.find_or_initialize_by(attributes).
          update_attributes!(bounding_box: bounding_box)
      else
        GeoEntity.find_or_create_by(attributes)
      end
    end
    Rails.logger.info("#{GeoEntity.countries.count - current_count} countries were created successfully!")
  end
end
