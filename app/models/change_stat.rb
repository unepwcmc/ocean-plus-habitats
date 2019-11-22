class ChangeStat < ApplicationRecord
  belongs_to :habitat, -> { where(name: 'mangroves') }
  belongs_to :geo_entity
  validates :habitat_id, uniqueness: true
  validates :geo_entity_id, uniqueness: true
end
