require 'csv'

namespace :import do
  desc "import CSV data into database"
  task :stats, [:csv_file] => [:environment] do

    habitats = Habitat.all

    habitats.each do |habitat|
      puts habitat.name
      csv_file = "#{habitat.name}.csv"

      # id -> integer
      # country_id -> integer (countries foreign key)
      # habitat_id -> integer (habitats foreign key)
      # total_area -> decimal
      # total_points -> integer (nil for habitats different from ColdCoral)
      # total_protected -> decimal (could potentially be used for both points and areas, so ColdCoral and other habitats)
      # protected_percentage -> decimal
      # change -> JSONB

    end

    def import_csv_file(habitat, csv_file)

    end

  end
end