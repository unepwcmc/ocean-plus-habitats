class Habitat < ApplicationRecord
  def global_coverage_title
    "Total global coverage of #{title.downcase}"
  end

  def protected_title
    "Percentage of #{title.downcase} that occur within a marine protected area"
  end
end
