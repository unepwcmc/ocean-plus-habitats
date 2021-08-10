require 'csv'

namespace :import do
  desc 'import CSV data into database'
  task :prebakedstats, [:csv_file] => [:environment] do
    habitats = Habitat.all
    dir = 'habitat_coverage_protection'
    geo_entity_types = %w[country regions].freeze

    # import habitat data CSVs for each entity type
    geo_entity_types.each do |geo_entity_type|
      habitats.each do |habitat|
        filename = "#{habitat.name}_#{geo_entity_type}_output_*.csv"
        csv_file = "#{dir}/#{geo_entity_type}/#{filename}"
        csv_file = ::Utilities::Files.latest_file_by_glob(csv_file)
        import_new_csv_file(habitat.name, csv_file)
      end
    end

    # Import occurrences for any countries that are missing (disregarding regions for the moment)
    # using habitat_country_presence.csv
    import_habitat_occurrences
  end

  def import_new_csv_file(habitat, csv_file)
    filename = "#{Rails.root}/lib/data/#{csv_file}"
    CSV.foreach(filename, headers: true, encoding: 'utf-8') do |row|
      # First we check whether it is a country (using ISO3) or a region depending on the CSV file
      # Then we fetch the geo entity. If it can't be found, fetch_geo_entity will return nil
      # Hence we can then skip any geo_entity that is nil
      name = row['iso3'] || row['region']
      geo_entity = fetch_geo_entity(name)
      next unless geo_entity

      insert_change_stat(habitat, geo_entity, row) if row.select { |k, _v| /baseline/i =~ k }.any?

      insert_geo_entity_stat(habitat, geo_entity, row)
    end
  end

  def insert_geo_entity_stat(habitat, geo_entity, csv_row)
    habitat = Habitat.find_by(name: habitat)

    latest_year = get_latest_year(csv_row.headers)
    total_value_column = latest_year ? "total_area_#{latest_year}" : 'total_area'
    protected_value = coerce_to_value(csv_row['protected_area'])
    total_value = coerce_to_value(csv_row[total_value_column])
    protected_percentage = coerce_to_value(csv_row['percent_protected'])

    GeoEntityStat.find_or_create_by(habitat: habitat, geo_entity: geo_entity) do |stat|
      stat.protected_value      = protected_value
      stat.total_value          = total_value
      stat.protected_percentage = protected_percentage
    end
  end

  def coerce_to_value(value)
    # Set value to nil for deficient data
    return if value == '-'

    value&.strip || 0
  end

  def get_latest_year(columns)
    columns.map { |c| c.split('_').last }.select do |c|
      next if c.nil?

      c.match(/\A\d+\z/)
    end.max
  end

  # At present this just applies to mangroves as only they have temporal data
  def insert_change_stat(habitat, geo_entity, csv_row)
    habitat = Habitat.find_by(name: habitat)

    ChangeStat.find_or_create_by(habitat: habitat, geo_entity: geo_entity) do |stat|
      stat.total_value_1996     = coerce_to_value(csv_row['total_area_1996'])
      stat.total_value_2007     = coerce_to_value(csv_row['total_area_2007'])
      stat.total_value_2008     = coerce_to_value(csv_row['total_area_2008'])
      stat.total_value_2009     = coerce_to_value(csv_row['total_area_2009'])
      stat.total_value_2010     = coerce_to_value(csv_row['total_area_2010baseline'])
      stat.total_value_2015     = coerce_to_value(csv_row['total_area_2015'])
      stat.total_value_2016     = coerce_to_value(csv_row['total_area_2016'])
      stat.protected_value      = coerce_to_value(csv_row['protected_area'])
      stat.protected_percentage = coerce_to_value(csv_row['percent_protected'])
    end
  end

  def fetch_geo_entity(name)
    if (name.include? '/') || (name.include? 'ABNJ') || (name.include? 'DPT')
      GeoEntity.find_by(name: 'Disputed')
    else
      GeoEntity.find_by(iso3: name) || GeoEntity.find_by(name: name)
    end
  end

  def import_habitat_occurrences
    countries = GeoEntity.countries.map(&:iso3)

    filename = 'lib/data/habitat_presence/habitat_presence_country.csv'

    CSV.foreach(filename, headers: true, encoding: 'utf-8') do |row|
      next unless countries.include?(row['ISO3'])

      Habitat.all.each do |habitat|
        stats = GeoEntity.find_by(iso3: row['ISO3']).geo_entity_stats

        next unless stats.find { |stat| stat.habitat == habitat }

        camel_cased_title = habitat.title.gsub(/[\s-]/, '_')

        stats.find_by(habitat: habitat).update(occurrence: row[camel_cased_title].to_i)
      end
    end
  end
end
