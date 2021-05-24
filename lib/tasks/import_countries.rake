require 'csv'

namespace :import do
  # Thanks to various non-ASCII characters in the CSV file, it messes with the show page
  # for each country as the URL cannot be properly generated
  def sanitise(string)
    I18n.transliterate(string)
  end

  desc 'import countries data into database'
  task countries: [:environment] do
    current_count = GeoEntity.countries.count
    Rails.logger.info("There are #{current_count} countries")

    CSV.foreach('lib/data/habitat_presence/habitat_presence_country.csv', headers: true) do |row|
      name = row['COUNTRY']
      iso3 = row['ISO3']

      attributes = {
        name: sanitise(name),
        iso3: iso3
      }

      GeoEntity.find_or_create_by(attributes)
    end

    Rails.logger.info("#{GeoEntity.countries.count - current_count} countries were created successfully!")
  end
end
