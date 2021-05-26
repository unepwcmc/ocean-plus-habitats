class GeoEntityStat < ApplicationRecord
  belongs_to :habitat
  belongs_to :geo_entity
  has_many :sources, through: :geo_entity_stats_sources
  has_many :geo_entity_stats_sources, class_name: 'GeoEntityStatsSources', dependent: :destroy

  scope :country_stats, -> { joins(:geo_entity).where('geo_entities.iso3 IS NOT NULL') }

  # TODO - consider adding :present-but-unknown to this list which will require some thinking
  enum occurrence: [:absent, :unknown, :present]

  BASE_OCCURRENCES = {
    'coralreefs' => 'unknown',
    'saltmarshes' => 'unknown',
    'mangroves' => 'unknown',
    'seagrasses' => 'unknown',
    'coldcorals' => 'unknown'
  }
end
