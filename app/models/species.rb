class Species < ApplicationRecord
  has_many :geo_entities_species, class_name: 'GeoEntitiesSpecies'
  has_many :geo_entities, through: :geo_entities_species
  belongs_to :habitat

  THREATENED = %w(CR EN VU).freeze
  NEAR_THREATENED = 'NT'.freeze
  LEAST_CONCERN = 'LC'.freeze
  OTHER_CATEGORIES = %w(DD NE).freeze
  IUCN_CATEGORIES = [THREATENED, NEAR_THREATENED, LEAST_CONCERN, OTHER_CATEGORIES].flatten.freeze
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
  scope :most_common, -> { where(redlist_status: LEAST_CONCERN) }
  scope :order_by_category, -> { order('redlist_status ASC') }

  def self.count_species(species = nil)
    species ||= all
    hash = count_by_category_and_habitat(species).compact
    hash.each do |habitat, categories_data|
      hash[habitat] = Species.fill_and_sort_by_category(categories_data)
    end
  end

  def self.find_habitats_without_data(hash)
    habitats_without_data = Habitat.pluck(:name) - hash.keys

  end

  def self.count_by_category_and_habitat(species)
    groupings = {}
    species.group_by { |s| [s.redlist_status, s.habitat.name] }.each do |key, values|
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
