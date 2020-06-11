class GlobalChangeStat < ApplicationRecord
  belongs_to :habitat, -> { where(name: 'mangroves') }
end
