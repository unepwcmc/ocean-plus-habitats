require 'csv'

namespace :import do

  desc "import CSV data into database"
  task :prebakedstats, [:csv_file] => [:environment] do
    habitats = Habitat.all
    geo_entity_types = ["countries", "regions"].freeze

    # import habitat data CSVs 
    geo_entity_types.each do |geo_entity_type|
      habitats.each do |habitat|
        puts habitat.name
        csv_file = "#{geo_entity_type}/#{habitat.name}.csv"

        puts csv_file
        import_new_csv_file(geo_entity_type, habitat.name, csv_file)
      end
    end
  end

  def import_new_csv_file(geo_entity_type, habitat, csv_file)
    filename = "#{Rails.root}/lib/data/#{csv_file}"
    csv = File.open(filename, encoding: "utf-8")
    csv_headers = File.readlines(csv).first.split(",")

    CSV.parse(csv, headers: true, encoding: "utf-8") do |row|
      csv_new_row = row.to_hash

      if csv_headers.grep(/baseline/).any?
        puts csv_new_row.inspect
        #byebug
        parse_change_stat csv_headers, csv_new_row, geo_entity_type, habitat
      else
        puts csv_new_row.inspect
        #byebug
        parse_geo_entity_stat csv_headers, csv_new_row, geo_entity_type, habitat
      end
    end
  end

  def parse_change_stat csv_headers, csv_row, geo_entity_type, habitat
    #puts "parse change"
    total_value_years = {}
 
    regionalstats_change_hash = {
      iso3: csv_headers[0],
      total_value_1996: csv_headers[1],
      total_value_2007: csv_headers[2],
      total_value_2008: csv_headers[3],
      total_value_2009: csv_headers[4],
      total_value_2010_baseline: csv_headers[5],
      total_value_2015: csv_headers[6],
      total_value_2016: csv_headers[7],
      protected_value: csv_headers[8],
      protected_percentage: csv_headers[9].chomp
    }.freeze

    total_value_array = [
      :total_value_1996,
      :total_value_2007,
      :total_value_2008,
      :total_value_2009,
      :total_value_2010_baseline,
      :total_value_2015,
      :total_value_2016
    ].freeze

    iso3, name = nil
    protected_value, protected_percentage = 0

    regionalstats_change_hash.keys.each do |key|  
      if key == :iso3
        iso3 = csv_row[strip_key(regionalstats_change_hash[key])]&.strip
      elsif key == :name
        name = csv_row[strip_key(regionalstats_change_hash[key])]&.strip
        #puts "iso3: #{iso3}"
      elsif total_value_array.include? key
        (total_value_years[key] ||= csv_row[strip_key(regionalstats_change_hash[key])]&.strip)
        #puts "total_value: #{total_value_years}"
      elsif key == :protected_value
        protected_value = csv_row[strip_key(regionalstats_change_hash[key])]&.strip
        #puts "protected_value: #{protected_value}"
      elsif key == :protected_percentage
        protected_percentage = csv_row[strip_key(regionalstats_change_hash[key])]&.strip
        #puts "protected_percentage: #{protected_percentage}"
      end
    end

    geo_entity = fetch_geo_entity(name, iso3)
    insert_change_stat(habitat, geo_entity, total_value_years, protected_value, protected_percentage)
  end

  def parse_geo_entity_stat csv_headers, csv_row, geo_entity_type, habitat
    #puts "parse standard"

    regionalstats_standard_hash = {
      iso3: csv_headers[0],
      total_value: csv_headers[1],
      total_value_protected: csv_headers[2],
      protected_percentage: csv_headers[3].chomp
    }.freeze

    iso3, name = nil
    total_value, total_value_protected, protected_percentage = 0

    regionalstats_standard_hash.keys.each do |key|
      if key == :iso3
        iso3 = csv_row[strip_key(regionalstats_standard_hash[key])]&.strip
      elsif key == :name
        name = csv_row[strip_key(regionalstats_standard_hash[key])]&.strip
        #puts "iso3: #{iso3}"
      elsif key == :total_value
        total_value = csv_row[strip_key(regionalstats_standard_hash[key])]&.strip
        #puts "total_value: #{total_value}"
      elsif key == :total_value_protected
        total_value_protected = csv_row[strip_key(regionalstats_standard_hash[key])]&.strip
        #puts "total_value_protected: #{total_value_protected}"
      elsif key == :protected_percentage
        protected_percentage = csv_row[strip_key(regionalstats_standard_hash[key])]&.strip
        #puts "protected_percentage: #{protected_percentage}"
      end
    end
    geo_entity = fetch_geo_entity(name, iso3)
    insert_geo_entity_stat(habitat, geo_entity, total_value, total_value_protected, protected_percentage)
  end

  def insert_geo_entity_stat(habitat, geo_entity, total_value, total_value_protected, protected_percentage)
    byebug
    country = nil
    habitat = Habitat.find_by(name: habitat)
    total_area, total_points = 0.0
    # puts "insert change regional stat: iso3: #{iso3}, total_value: #{total_value}, 
    # total_value_protected: #{total_value_protected}, protected_percentage: #{protected_percentage}"
    if (iso3.include? "/") || (iso3.include? "ABNJ")
      puts "Disputed territory #{iso3}"
      country = Country.find_by(name: "Disputed")
    else
      country = Country.find_by(iso3: iso3)
    end
    puts "Country is: #{country&.name}, habitat is: #{habitat.name}"
    if habitat.name == "coldcorals"
      total_points = total_value
    else
      total_area = total_value
    end
    RegionalStat.create(habitat: habitat, country: country, total_area: total_area || 0, 
                        total_points: total_points || 0, total_protected: total_value_protected || 0, 
                        protected_percentage: protected_percentage || 0)
  end

  def insert_change_stat(habitat, geo_entity, total_value_years, protected_value, protected_percentage)
    byebug
    country = nil
    habitat = Habitat.find_by(name: habitat)
    # puts "insert change regional stat: iso3: #{iso3}, total_value_years: #{total_value_years}, 
    # protected_value: #{protected_value}, protected_percentage: #{protected_percentage}"
    if (iso3.include? "/") || (iso3.include? "ABNJ")
      puts "Disputed territory #{iso3}"
      country = Country.find_by(name: "Disputed")
    else
      country = Country.find_by(iso3: iso3)
    end
    ChangeStat.create(habitat: habitat, country: country, 
                      total_value_1996: total_value_years[:total_value_1996] || 0,
                      total_value_2007: total_value_years[:total_value_2007] || 0,
                      total_value_2008: total_value_years[:total_value_2008] || 0,
                      total_value_2009: total_value_years[:total_value_2009] || 0,
                      total_value_2010: total_value_years[:total_value_2010_baseline] || 0,
                      total_value_2015: total_value_years[:total_value_2015] || 0,
                      total_value_2016: total_value_years[:total_value_2016] || 0,
                      protected_value: protected_value,
                      protected_percentage: protected_percentage
                      )
  end

  def strip_key key
    key.tr('"\"', '')
  end

  def fetch_geo_entity(name, iso3)
    byebug
    if name.present?
      geo_entity = GeoEntity.find_by(name: name)
    elsif (iso3.include? "/") || (iso3.include? "ABNJ")
      puts "Disputed territory #{iso3}"
      geo_entity = GeoEntity.find_by(name: "Disputed")
    else
      geo_entity = GeoEntity.find_by(iso3: iso3)
    end
    geo_entity
  end

end