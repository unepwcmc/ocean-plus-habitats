class CountryCitation < ApplicationRecord
  belongs_to :geo_entity, foreign_key: 'country_id'
end
