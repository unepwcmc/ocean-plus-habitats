class GeoEntity < ApplicationRecord
  has_many :geo_entities_species, class_name: 'GeoEntitiesSpecies'
  has_many :species, through: :geo_entities_species
  has_many :geo_entity_stats
  # At the moment, only mangroves have got change stats,
  # which means there can only be one change_stat record per country.
  # This can change in the future
  has_one :change_stat
  has_one :coastal_stat

  has_many :region_relationship, foreign_key: :country_id, class_name: 'GeoRelationship'
  has_many :regions, through: :region_relationship, class_name: 'GeoEntity'
  has_many :country_relationship, foreign_key: :region_id, class_name: 'GeoRelationship'
  has_many :countries, through: :country_relationship, class_name: 'GeoEntity'

  has_many :country_citations, foreign_key: 'country_id'

  scope :countries, -> { where.not(iso3: nil) }
  scope :regions, -> { where(iso3: nil) }

  # Returns species data if directly attached to the GeoEntity, so a country.
  # Returns species data for all associated countries if it is a region.
  # With the current importers, species are directly associated to regions
  # via the geo_entity_id.
  # TODO Consider removing this method
  def all_species
    return species if species.present?
    Species.joins(:geo_entities).where(geo_entities: { id: countries.map(&:id) })
  end

  def count_species
    Species.count_species(all_species)
  end

  def occurrences
    _occurrences = countries_geo_entity_stats.joins(:habitat).select('habitats.name, occurrence')
    _occurrences = _occurrences.map(&:attributes).map { |attrs| attrs.slice('name', 'occurrence') }
    hash = {}

    _occurrences.map do |occurrence|
      _occurrence = occurrence['occurrence']
      next if hash[occurrence['name']] == 'present'
      hash[occurrence['name']] = _occurrence unless _occurrence == 'unknown'
    end
    GeoEntityStat::BASE_OCCURRENCES.merge(hash)
  end

  def protection_stats
    sql_select = <<-SQL
      habitats.name,
      geo_entity_stats.total_value,
      geo_entity_stats.protected_value,
      geo_entity_stats.protected_percentage
    SQL

    geo_entity_stats.joins(:habitat).
      select(sql_select).
      map(&:attributes).map { |ges| ges.except('id') }.
      group_by { |ges| ges['name'] }.
      transform_values(&:first)
  end

  def calculated_protection_stats
    _protection_stats = countries_geo_entity_stats.joins(:habitat).select('
      habitats.name,
      geo_entity_stats.total_value,
      geo_entity_stats.protected_value
    ')
    _protection_stats = _protection_stats.map(&:attributes).map do |attrs|
      attrs.slice('name', 'total_value', 'protected_value')
    end

    _protection_stats = _protection_stats.group_by { |ps| ps['name'] }
    hash = {}
    _protection_stats.keys.map do |habitat|
      hash[habitat] ||= {}
      hash[habitat]['total_value'] = _protection_stats[habitat].inject(0) { |sum, x| sum + x['total_value'] }
      hash[habitat]['protected_value'] = _protection_stats[habitat].inject(0) { |sum, x| sum + x['protected_value'] }
    end
    hash.each do |habitat, h|
      total_value = h['total_value'] > 0 ? h['total_value'] : 1
      h['protected_percentage'] = h['protected_value'] / total_value * 100
    end
    hash
  end

  private

  # TODO Consider removing this and using directly associated stats for regions too
  def countries_geo_entity_stats
    countries.present? ? GeoEntityStat.where(geo_entity_id: countries.map(&:id)) : geo_entity_stats
  end

  # most common is to be determined in a meeting
  # most threatened is to be ordered as follows;
  #
  # Critically Endangered, Endangered, Vulnerable
  # CR is the most endangered, then comes EN, third VU
  # and if there are not 3 species of these categories, NT (near threatened)
  # could also be considered.

  # Example output:
  # => ["Tabebuia palustris", nil, "VU", "Pelliciera rhizophoreae", nil, "VU", "Avicennia bicolor", nil, "VU"]
end
