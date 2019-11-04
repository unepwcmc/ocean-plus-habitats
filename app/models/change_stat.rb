class ChangeStat < ApplicationRecord
  belongs_to :habitat, -> { where(name: 'mangroves') }
  belongs_to :geo_entity
end
