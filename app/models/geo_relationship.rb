class GeoRelationship < ApplicationRecord
  belongs_to :country, class_name: 'GeoEntity'
  belongs_to :region, class_name: 'GeoEntity'
end
