require 'csv'

namespace :import do
  desc "import global change data into database"
  task :global_change => [:environment] do
    CSV.foreach('lib/data/global_habitat_change.csv', headers: true) do |row|
      habitat, percentage_lost, baseline_year, recent_year, reference
      habitat = Habitat.where(title: habitat.downcase)
      if percentage_lost.test(/[-%]/)

      else

      end


    end

  end
end
