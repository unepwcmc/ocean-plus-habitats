require 'csv'

namespace :import do
  desc "import CSV data into database"
  task :prebakedstats, [:csv_file] => [:environment] do
    habitats = Habitat.all
    geo_entity_types = ["countries", "regions"].freeze

    # import habitat data CSVs for each entity type
    geo_entity_types.each do |geo_entity_type|
      habitats.each do |habitat|
        csv_file = "#{geo_entity_type}/#{habitat.name}.csv"
        import_new_csv_file(habitat.name, csv_file)
      end
    end
  end

  def import_new_csv_file(habitat, csv_file)
    filename = "#{Rails.root}/lib/data/#{csv_file}"
    CSV.foreach(filename, headers: true, encoding: "utf-8") do |row|
      if row.select {|k,v| /baseline/i =~ k}.any?
        parse_change_stat(row, habitat)
      end
      parse_geo_entity_stat(row, habitat)
    end
  end

  def parse_change_stat(csv_row, habitat)
    name = csv_row["name"] || csv_row["Region"]
    geo_entity = fetch_geo_entity(name, csv_row["iso3"])
    insert_change_stat(habitat, geo_entity, csv_row)
  end

  def parse_geo_entity_stat(csv_row, habitat)
    name = csv_row["name"] || csv_row["Region"]
    geo_entity = fetch_geo_entity(name, csv_row["iso3"])
    insert_geo_entity_stat(habitat, geo_entity, csv_row)
  end

  def insert_geo_entity_stat(habitat, geo_entity, csv_row)
    habitat = Habitat.find_by(name: habitat)

    latest_year = get_latest_year(csv_row.headers)
    total_value_column = latest_year ? "total_value_#{latest_year}" : 'total_value'
    protected_value = csv_row["protected_value"]&.strip || 0
    total_value = csv_row[total_value_column]&.strip || 0
    protected_percentage = csv_row["protected_percentage"]&.strip || 0

    GeoEntityStat.create(habitat: habitat, geo_entity: geo_entity, protected_value: protected_value,
                        total_value: total_value, protected_percentage: protected_percentage)
  end

  def get_latest_year(columns)
    columns.map { |c| c.split('_').last }.
      select { |c| c.match(/\A\d+\z/) }.
      max
  end

  def insert_change_stat(habitat, geo_entity, csv_row)
    habitat = Habitat.find_by(name: habitat)

    ChangeStat.create(habitat: habitat, geo_entity: geo_entity,
                      total_value_1996: csv_row["total_value_1996"]&.strip || 0,
                      total_value_2007: csv_row["total_value_2007"]&.strip || 0,
                      total_value_2008: csv_row["total_value_2008"]&.strip || 0,
                      total_value_2009: csv_row["total_value_2009"]&.strip || 0,
                      total_value_2010: csv_row["total_value_2010_baseline"]&.strip || 0,
                      total_value_2015: csv_row["total_value_2015"]&.strip || 0,
                      total_value_2016: csv_row["total_value_2016"]&.strip || 0,
                      protected_value: csv_row["protected_value"]&.strip || 0,
                      protected_percentage: csv_row["protected_percentage"]&.strip || 0
                      )
  end

  def fetch_geo_entity(name, iso3)
    if name.present?
      geo_entity = GeoEntity.find_by(name: name)
    elsif (iso3.include? "/") || (iso3.include? "ABNJ")
      geo_entity = GeoEntity.find_by(name: "Disputed")
    else
      geo_entity = GeoEntity.find_by(iso3: iso3) || nil
    end
    geo_entity
  end
end
