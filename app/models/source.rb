class Source < ApplicationRecord
  has_many :geo_entity_stats_sources, class_name: 'GeoEntityStatsSources',
           foreign_key: 'citation_id', primary_key: 'citation_id', dependent: :destroy
  has_many :geo_entity_stats, through: :geo_entity_stats_sources
end
