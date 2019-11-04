class GeoEntity < ApplicationRecord
  has_many :country_stats
  has_many :regional_stats
  # At the moment, only mangroves have got change stats,
  # which means there can only be one change_stat record per country.
  # This can change in the future
  has_one :change_stat
end