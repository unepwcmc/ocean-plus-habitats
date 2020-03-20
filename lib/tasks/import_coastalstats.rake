require 'csv'

namespace :import do
  desc "import CSV data into database"
  task :coastalstats, [:csv_file] => [:environment] do
    filename = 'coastline_coverage'
    csv_file = "#{Rails.root}/lib/data/#{filename}/#{filename}.csv"

    import_csv_file(csv_file)
  end

  def import_csv_file(csv_file)
    CSV.foreach(csv_file, headers: true, encoding: 'utf-8') do |row|
      # temporary workaround to catch only one buffer
      next unless row['buffer'] == '30'
      habitats = Habitat.all
      name = row['iso3'] || row['name']
      geo_entity = fetch_geo_entity(name)
      habitats.each do |habitat|
        parse_coastal_stat(row, habitat, geo_entity)
      end
    end
  end

  def parse_coastal_stat(csv_row, habitat, geo_entity)
    insert_coastal_coverage(habitat, geo_entity, csv_row)
    insert_coastal_stat(geo_entity, csv_row)
  end

  def insert_coastal_coverage(habitat, geo_entity, csv_row)
    column = "#{habitat.name}_length"
    coastline_coverage = csv_row[column.to_s]

    ges = GeoEntityStat.find_or_create_by(habitat: habitat, geo_entity: geo_entity)
    ges.update_attributes(coastal_coverage: coastline_coverage)
  end

  def insert_coastal_stat(geo_entity, csv_row)
    attributes = {
      total_coast_length: csv_row['total_coastal_length'],
      multiple_habitat_length: csv_row['multiple_length']
     }

    coast = CoastalStat.find_or_create_by(geo_entity: geo_entity)
    coast.update_attributes(attributes)
  end
end
