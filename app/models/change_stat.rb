class ChangeStat < ApplicationRecord
  belongs_to :habitat, -> { where(name: 'mangroves') }
  belongs_to :country
end
