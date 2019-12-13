class Species < ApplicationRecord
  has_many :geo_entities_species, class_name: 'GeoEntitiesSpecies', primary_key: 'species_id'
  has_many :geo_entities, through: :geo_entities_species
  belongs_to :habitat

  THREATENED = %w(CR EN VU).freeze
  NEAR_THREATENED = 'NT'.freeze
  LEAST_CONCERN = %w(LC DD NE).freeze
  IUCN_CATEGORIES = [THREATENED, NEAR_THREATENED, LEAST_CONCERN].flatten.freeze
  # most common is to be determined in a meeting
  # most threatened is to be ordered as follows;
  #
  # Critically Endangered, Endangered, Vulnerable
  # CR is the most endangered, then comes EN, third VU
  # and if there are not 3 species of these categories, NT (near threatened)
  # could also be considered.

  # Example output:
  # => ["Tabebuia palustris", nil, "VU", "Pelliciera rhizophoreae", nil, "VU", "Avicennia bicolor", nil, "VU"]

  scope :threatened, -> { where(redlist_status: THREATENED) }
  scope :near_threatened, -> { where(redlist_status: NEAR_THREATENED) }
  scope :threatened_and_near, -> { where(redlist_status: [THREATENED, NEAR_THREATENED].flatten) }
  scope :not_threatened, -> { where.not(redlist_status: THREATENED) }

  def self.count_by_category_and_habitat(species = nil)
    species ||= all
    groupings = {}
    species.group_by { |s| [s.redlist_status, s.habitat.name] }.map do |key, values|
      groupings[key.last] ||= {}
      groupings[key.last].merge!({ "#{key.first}" => values.count })
    end

    groupings.each do |habitat, values_hash|
      groupings[habitat]['total'] = values_hash.inject(0) { |sum, x| sum + x.last }
    end
  end

  def self.fill_and_sort_by_category(data)
    IUCN_CATEGORIES.each do |cat|
      data[cat] ||= 0
    end
    data.sort_by { |k, _| IUCN_CATEGORIES.index(k) || data.length }
  end
end
