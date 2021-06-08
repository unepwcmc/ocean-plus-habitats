class GeoEntityStatsSources < ApplicationRecord
  belongs_to :source, primary_key: 'citation_id', foreign_key: 'citation_id'
  belongs_to :geo_entity_stat
end
