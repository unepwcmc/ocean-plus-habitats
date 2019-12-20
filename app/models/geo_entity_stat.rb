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
end
