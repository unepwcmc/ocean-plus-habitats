require 'csv'

namespace :import do
  desc "import RedList species data into database"
  task :redlist_data => [:environment] do
    HABITATS = %w(mangroves seagrasses coralreefs coldcorals).freeze
    SPECIES_HEADER = Species.new.attributes.keys.freeze

    HABITATS.each do |habitat|
      habitat_obj = Habitat.find_by(name: habitat)

      unless habitat_obj.present?
        p "Habitat #{habitat} not found!"
        next
      end

      filename = "lib/data/species/#{habitat}/species-utf8.csv"

      p "=====PROCESSING #{habitat}====="

      CSV.foreach(filename, headers: true) do |row|
        # TODO Remove empty rows from CSVs
        next unless row['species_id']
        row_hash = row.to_hash.slice(*SPECIES_HEADER)
        Species.create(row_hash.merge(habitat_id: habitat_obj.id))
      end
    end
  end
end
