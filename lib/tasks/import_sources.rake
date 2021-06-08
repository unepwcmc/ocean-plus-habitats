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

  desc 'import sources for each habitat for each country' 
  task :habitat_sources_per_country => [:environment] do
    # habitat_presence_country contains the source IDs for each habitat
    CSV.foreach('lib/data/habitat_presence/habitat_presence_country.csv', headers: true) do |row|
      geo_entity = GeoEntity.find_by(iso3: row['ISO3'])

      next unless geo_entity

      Habitat.all.each do |habitat|
        # Fetch the source IDs from the relevant column
        camelcased_habitat_title = habitat.title.gsub(/[\s-]/, '_')

        source_ids = row["Sources_#{camelcased_habitat_title}"].split(';').map(&:to_i)
        stat = GeoEntityStat.find_by(habitat_id: habitat.id, geo_entity_id: geo_entity.id)

        source_ids.each do |id|
          source = Source.find_by(citation_id: id)

          unless source
            Rails.logger.info("Source not found in the database with id #{id}")
            next
          end

          GeoEntityStatsSources.find_or_create_by(geo_entity_stat_id: stat.id, citation_id: source.citation_id)
        end
      end
    end

    puts "#{GeoEntityStatsSources.count} GeoEntityStatsSources were created"
  end
end
