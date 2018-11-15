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
          puts "iso3: #{iso3}"
        elsif key == :value
          value = csv_staticstats_row[staticstats_hash[key]]&.strip
          puts "value: #{value}"
        end
      end
      
      if csv_file.include? "Protected"
        puts "insert Protected value into habitat #{habitat}: #{value} into iso3: #{iso3}"
      elsif csv_file.include? "Total"
        puts "insert Total value into habitat #{habitat}: #{value} into iso3: #{iso3}"
      end
    end
      
    csv.close
    
  end
  
end
