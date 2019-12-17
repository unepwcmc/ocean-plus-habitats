class GeoEntityStat < ApplicationRecord
  belongs_to :habitat
  belongs_to :geo_entity

  enum occurrence: [:absent, :uknown, :present]
end
