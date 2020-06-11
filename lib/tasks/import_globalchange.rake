require 'csv'

namespace :import do
  desc "import global change data into database"
  task :global_change => [:environment] do
    CSV.foreach('lib/data/habitat_coverage_protection/global_habitat_change.csv', {headers: true, encoding: 'iso-8859-1:utf-8'}) do |row|
      next if row.nil?
      habitat = Habitat.where(name: row['habitat'].downcase).first
      if row['percentage_lost'].match(/[-%]/)
        lower_bound_percentage = row['percentage_lost'].split('-').first.strip
        upper_bound_percentage = row['percentage_lost'].split('-').last.strip.chop
      else
        percentage_lost = row['percentage_lost']
      end

      percentages = [lower_bound_percentage, upper_bound_percentage, percentage_lost]
      percentages.map { |percentage| percentage = percentage.nil? ? 0 : percentage }

      baseline_year = row['baseline_year']
      recent_year = row['recent_year']

      GlobalChangeStat.find_or_create_by(habitat: habitat, percentage_lost: percentage_lost, lower_bound_percentage: lower_bound_percentage,
      upper_bound_percentage: upper_bound_percentage, baseline_year: baseline_year, recent_year: recent_year)

      references = []
      references = row['reference'].match(/(\n\n)/) ? row['reference'].split("\n\n") : references << row['reference']

      citation = references.first
      url = 'No URL specified'

      references.each do |reference|
        if reference.match(/(http)/)
          if reference.match(/(URL:|doi:)/)
            citation = reference.split('URL:' || 'doi:').first.strip
            url = reference.split('URL:' || 'doi:').last.strip
          else
            citation = reference.split(' ')[0..-2].join(' ')
            url = reference.split(' ').last.strip
          end
        end
      GlobalChangeCitation.find_or_create_by(citation: citation, citation_url: url,
        global_change_stat_id: GlobalChangeStat.where(habitat_id: habitat).first.id)
      end
    end

  end
end
