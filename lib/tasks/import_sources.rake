require 'csv'

namespace :import do
  desc 'import sources data into database'
  task :sources => [:environment] do
    current_count = Source.count
    puts "There are #{current_count} sources"

    CSV.foreach('lib/data/habitat_presence/all-sources-list.csv', headers: true) do |row|
      source_id = row['SourceID']
      citation = row['Citation'] || [
        row['Title'], row['Author1'], row['Author2'], row['Author3'],
        row['Year'], row['Publisher']
      ].reject(&:blank?).join(',')
      source_url = row['Link']
      attributes = {
        citation_id: source_id,
        citation: citation,
        source_url: source_url
      }
      Source.find_or_create_by(attributes)
    end
    puts "#{Source.count - current_count} sources imported"
  end

  desc 'import country citations data into database'
  task :country_citations => [:environment] do
    current_count = CountryCitation.count
    puts "There are #{current_count} citations"

    CSV.foreach('lib/data/habitat_presence/citations_country.csv', headers: true) do |row|
      country_id = GeoEntity.find_by(iso3: row['ISO3']).try(:id)
      unless country_id
        puts "Country with iso code #{row['ISO3']} not found"
        next
      end
      citation = row['Citation']
      attributes = {
        country_id: country_id,
        citation: citation
      }
      CountryCitation.find_or_create_by(attributes)
    end
    puts "#{CountryCitation.count - current_count} citations imported"
  end
end
