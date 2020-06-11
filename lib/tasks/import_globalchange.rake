require 'csv'

namespace :import do
  desc "import global change data into database"
  task :global_change => [:environment] do
    CSV.foreach('lib/data/global_habitat_change.csv', headers: true) do |row|
      habitat = Habitat.where(title: row['habitat'].downcase)
      if row['percentage_lost'].test(/[-%]/)
        lower_bound_percentage = row['percentage_lost'].split('-').first
        upper_bound_percentage = row['percentage_lost'].split('-').last
      else
        percentage_lost = row['percentage_lost']
      end
      baseline_year = row['baseline_year']
      recent_year = row['recent_year']
      reference = row['reference']

      GlobalChangeStat.new(habitat: habitat, percentage_lost: percentage_lost, lower_bound_percentage: lower_bound_percentage,
      upper_bound_percentage: upper_bound_percentage, baseline_year: baseline_year, recent_year: recent_year,
      reference: reference)
    end

  end
end
