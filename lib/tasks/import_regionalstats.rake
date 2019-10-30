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

    # db structure:

    # id -> integer
    # country_id -> integer (countries foreign key)
    # habitat_id -> integer (habitats foreign key)
    # total_area -> decimal
    # total_points -> integer (nil for habitats different from ColdCoral)
    # total_protected -> decimal (could potentially be used for both points and areas, so ColdCoral and other habitats)
    # protected_percentage -> decimal

    # #<RegionalStat id: nil, habitat_id: nil, country_id: nil, total_area: 0.0, total_points: 0.0, total_protected: 0.0, protected_percentage: 0.0, created_at: nil, updated_at: nil> 

    # csv structure:

    # "iso3","total_value_1996","total_value_2007","total_value_2008","total_value_2009","total_value_2010_baseline","total_value_2015","total_value_2016","protected_value","protected_percentage"

    filename = "#{Rails.root}/lib/data/#{csv_file}"
    csv = File.open(filename, encoding: "utf-8")
    csv_headers = File.readlines(csv).first.split(",")

    puts habitat
    puts csv_headers
    puts csv_headers.length

    if csv_headers.grep(/baseline/).any?
      parse_special
    else
      parse_normal
    end
  end

  def parse_special
    puts "parse special"
  end

  def parse_normal
    puts "parse normal"
  end

end