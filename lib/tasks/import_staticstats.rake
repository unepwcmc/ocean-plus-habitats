require 'csv'

namespace :import do
  desc "import CSV data into database"
  task :staticstats, [:csv_file] => [:environment] do |t, args|

    habitats = Habitat.all
    
    habitats.each do |habitat|
      csv_file = "#{habitat.name.capitalize}_Protected.csv"
      puts "import CSV: #{csv_file}"
      import_csv_file(habitat.name, csv_file)
      
      csv_file = "#{habitat.name.capitalize}_Total.csv"
      puts "import CSV: #{csv_file}"
      import_csv_file(habitat.name, csv_file)     
    end

  end
  
  def import_csv_file(habitat, csv_file)
    puts "CSV file: #{csv_file}"
    
    filename = "#{Rails.root}/lib/data/#{csv_file}"
    
    csv = File.open(filename, encoding: "utf-8")
    csv_headers = File.readlines(csv).first.split(",")
    
    staticstats_hash = {
      iso3: csv_headers[0],
      value: csv_headers[1].chomp
    }
    
    CSV.parse(csv, headers: true, encoding: "utf-8") do |row|
      csv_staticstats_row = row.to_hash
      staticstats_row_hash = {}
      iso3 = ""
      value = 0

      staticstats_hash.keys.each do |key|
        if key == :iso3
          iso3 = csv_staticstats_row[staticstats_hash[key]]&.strip
        elsif key == :value
          value = csv_staticstats_row[staticstats_hash[key]]&.strip
        end
      end
      
      if csv_file.include? "Protected"
        insert_static_stat("protected", habitat, iso3, value)
      elsif csv_file.include? "Total"
        insert_static_stat("total", habitat, iso3, value)
      end
    end
      
    csv.close
    
  end
  
  def insert_static_stat(kind, habitat, iso3, value)
    return if iso3.include? "/"
    return if iso3.include? "ABNJ"
    puts "insert #{kind} value into habitat #{habitat}: #{value} into iso3: #{iso3}"
    country = Country.find_by(iso3: iso3) rescue nil
    habitat = Habitat.find_by(name: habitat) rescue nil

    if country.nil? || habitat.nil?
      byebug
      "Cannot import #{kind} value into habitat #{habitat}: #{value} into iso3: #{iso3}"
      return
    end

    static_stat = StaticStat.find_or_create_by(country_id: country.id, habitat_id: habitat.id)

    if kind == "protected"
      static_stat.protected_value = value
    elsif kind == "total"
      static_stat.total_value = value
    end

    unless static_stat.save!
      Rails.logger.info "Cannot import #{kind} value into habitat #{habitat}: #{value} into iso3: #{iso3}"
    end

  end

end
