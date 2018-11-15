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
      value: csv_headers[1]
    }
    
    CSV.parse(csv, headers: true, encoding: "utf-8") do |row|
      csv_staticstats_row = row.to_hash
      staticstats_row_hash = {}

      staticstats_hash.keys.each do |key|
        if key == :iso3
          puts "iso3: #{csv_staticstats_row[staticstats_hash[key]]&.strip}"
        elsif key == :value
          puts "value: #{csv_staticstats_row[staticstats_hash[key]]&.strip}"
        end
      end
      
    end
      
    csv.close
    
  end
  
end
