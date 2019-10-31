require 'csv'

namespace :import do

  desc "import CSV data into database"
  task :regionalstats, [:csv_file] => [:environment] do
    habitats = Habitat.all

    habitats.each do |habitat|
      puts habitat.name
      csv_file = "#{habitat.name}.csv"

      import_regional_csv_file(habitat.name, csv_file)
    end
  end

  def import_regional_csv_file(habitat, csv_file)
    filename = "#{Rails.root}/lib/data/#{csv_file}"
    csv = File.open(filename, encoding: "utf-8")
    csv_headers = File.readlines(csv).first.split(",")

    CSV.parse(csv, headers: true, encoding: "utf-8") do |row|
      csv_regionalstats_row = row.to_hash

      if csv_headers.grep(/baseline/).any?
        parse_change csv_headers, csv_regionalstats_row, habitat
      else
        parse_standard csv_headers, csv_regionalstats_row, habitat
      end
    end
  end

  def parse_change csv_headers, csv_row, habitat
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

    iso3 = nil
    protected_value, protected_percentage = 0

    regionalstats_change_hash.keys.each do |key|  
      if key == :iso3
        iso3 = csv_row[strip_key(regionalstats_change_hash[key])]&.strip
        #puts "iso3: #{iso3}"
      elsif total_value_array.include? key
        (total_value_years[key] ||= []) << csv_row[strip_key(regionalstats_change_hash[key])]&.strip
        #puts "total_value: #{total_value_years}"
      elsif key == :protected_value
        protected_value = csv_row[strip_key(regionalstats_change_hash[key])]&.strip
        #puts "protected_value: #{protected_value}"
      elsif key == :protected_percentage
        protected_percentage = csv_row[strip_key(regionalstats_change_hash[key])]&.strip
        #puts "protected_percentage: #{protected_percentage}"
      end
    end

    insert_change_regional_stat(habitat, iso3, total_value_years, protected_value, protected_percentage)
  end

  def parse_standard csv_headers, csv_row, habitat
    #puts "parse standard"

    regionalstats_standard_hash = {
      iso3: csv_headers[0],
      total_value: csv_headers[1],
      total_value_protected: csv_headers[2],
      protected_percentage: csv_headers[3].chomp
    }.freeze

    iso3 = nil
    total_value, total_value_protected, protected_percentage = 0

    regionalstats_standard_hash.keys.each do |key|
      if key == :iso3
        iso3 = csv_row[strip_key(regionalstats_standard_hash[key])]&.strip
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

    insert_standard_regional_stat(habitat, iso3, total_value, total_value_protected, protected_percentage)
  end

  def insert_standard_regional_stat(habitat, iso3, total_value, total_value_protected, protected_percentage)
    country = nil
    habitat = Habitat.find_by(name: habitat)
    total_area, total_points = 0.0
    puts "insert change regional stat: iso3: #{iso3}, total_value: #{total_value}, 
    total_value_protected: #{total_value_protected}, protected_percentage: #{protected_percentage}"
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

  def insert_change_regional_stat(habitat, iso3, total_value_years, protected_value, protected_percentage)
    country = nil
    habitat = Habitat.find_by(name: habitat)
    puts "insert change regional stat: iso3: #{iso3}, total_value_years: #{total_value_years}, 
    protected_value: #{protected_value}, protected_percentage: #{protected_percentage}"
    if (iso3.include? "/") || (iso3.include? "ABNJ")
      puts "Disputed territory #{iso3}"
      country = Country.find_by(name: "Disputed")
    else
      country = Country.find_by(iso3: iso3)
    end
    puts "Country is: #{country&.name}, habitat is: #{habitat.name}"
    puts "total_value_1996: #{total_value_years[:total_value_1996]}
    total_value_2007: #{total_value_years[:total_value_2007]}
    total_value_2008: #{total_value_years[:total_value_2008]}
    total_value_2009: #{total_value_years[:total_value_2009]}
    total_value_2010: #{total_value_years[:total_value_2010_baseline]}
    total_value_2015: #{total_value_years[:total_value_2015]}
    total_value_2016: #{total_value_years[:total_value_2016]}"
    byebug
    ChangeStat.create(habitat: habitat, country: country, 
                      total_value_1996: total_value_years[:total_value_1996],
                      total_value_2007: total_value_years[:total_value_2007],
                      total_value_2008: total_value_years[:total_value_2008],
                      total_value_2009: total_value_years[:total_value_2009],
                      total_value_2010: total_value_years[:total_value_2010_baseline],
                      total_value_2015: total_value_years[:total_value_2015],
                      total_value_2016: total_value_years[:total_value_2016]
                      # ,
                      # protected_value: protected_value || 0,
                      # protected_percentage: protected_percentage || 0
                      )
  end

  def strip_key key
    key.tr('"\"', '')
  end
end