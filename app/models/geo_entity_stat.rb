class GeoEntityStat < ApplicationRecord
  belongs_to :habitat
  belongs_to :geo_entity

  scope :country_stats, -> { joins(:geo_entity).where('geo_entities.iso3 IS NOT NULL') }

  enum occurrence: [:absent, :unknown, :present]

  BASE_OCCURRENCES = {
    'coralreefs' => 'unknown',
    'saltmarshes' => 'unknown',
    'mangroves' => 'unknown',
    'seagrasses' => 'unknown',
    'coldcorals' => 'unknown'
  }

  def self.to_csv
    require 'csv'
    attributes = %w[Country Habitat Total_value(km^2) Protected_value(km^2) Protected_percentage Coastal_coverage(km)]
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.order(:geo_entity_id, :habitat_id).each do |ges|
        csv << [ges.geo_entity.name, ges.habitat.name, ges.total_value, ges.protected_value, ges.protected_percentage, ges.coastal_coverage]
      end
    end
  end
end
