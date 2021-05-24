require 'csv'

namespace :import do
  desc 'import countries data into database'
  task countries: [:environment] do
    # Strip out accents, commas, apostrophes, brackets as they mess with the URL
    def sanitize(name) 
      I18n.transliterate(name).gsub(/[,'()]/, '')
    end

    current_count = GeoEntity.countries.count
    Rails.logger.info("There are #{current_count} countries")

    CSV.foreach('lib/data/habitat_presence/habitat_presence_country.csv', headers: true) do |row|
      name = row['COUNTRY']
      iso3 = row['ISO3']

      attributes = {
        name: sanitize(name), # this name used for URLs
        actual_name: name, # leave original name in there for purposes of displaying to users
        iso3: iso3
      }

      GeoEntity.find_or_create_by(attributes)
    end

    Rails.logger.info("#{GeoEntity.countries.count - current_count} countries were created successfully!")
  end
end
