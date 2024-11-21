class ChangeStat < ApplicationRecord
  belongs_to :habitat, -> { where(name: 'mangroves') }
  belongs_to :geo_entity
  has_many :change_stats_total_values
  validates :habitat_id, uniqueness: { scope: :geo_entity_id }
end
