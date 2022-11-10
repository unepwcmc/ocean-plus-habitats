class GeoEntityStat < ApplicationRecord
  belongs_to :habitat
  belongs_to :geo_entity
  has_many :sources, through: :geo_entity_stats_sources
  has_many :geo_entity_stats_sources, class_name: 'GeoEntityStatsSources', dependent: :destroy

  scope :country_stats, lambda {
    joins(:geo_entity).where.not('geo_entities.iso3': nil)
      .where.not('geo_entities.iso3': 'GBL')
  }

  # TODO: - consider adding :present-but-unknown to this list which will require some thinking
  enum occurrence: %i[absent unknown present]

  BASE_OCCURRENCES = {
    'coralreefs' => 'unknown',
    'saltmarshes' => 'unknown',
    'mangroves' => 'unknown',
    'seagrasses' => 'unknown',
    'coldcorals' => 'unknown'
  }.freeze

  def api_json
    {
      name: habitat.name,
      total_area: protected_value,
      protected_area: total_value,
      percent_protected: protected_percentage
    }
  end
end
