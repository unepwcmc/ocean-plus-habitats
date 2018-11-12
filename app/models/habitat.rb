class Habitat < ApplicationRecord
  def global_coverage_title
    "Total global coverage of #{title.downcase}"
  end

  def protected_title
    "Percentage of #{title.downcase} that occur within a marine protected area"
  end

  def calculate_global_coverage
    coverage = Carto.new(name).total_area.first['sum']
    update_attributes(global_coverage: coverage.round)
  end
end
