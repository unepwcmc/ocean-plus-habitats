class GeoEntityStat < ApplicationRecord
  belongs_to :habitat
  belongs_to :geo_entity

  enum occurrence: [:absent, :unknown, :present]

  BASE_OCCURRENCES = {
    'coralreefs' => 'unknown',
    'saltmarshes' => 'unknown',
    'mangroves' => 'unknown',
    'seagrasses' => 'unknown',
    'coldcorals' => 'unknown'
  }
end
