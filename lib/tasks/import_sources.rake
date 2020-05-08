require 'csv'

namespace :import do
  desc 'import sources data into database'
  task :sources => [:environment] do
    current_count = Source.count
    puts "There are #{current_count} sources"

    CSV.foreach('lib/data/habitat_presence/all-sources-list.csv', headers: true) do |row|
      source_id = row['SourceID']
      citation = [
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
end
