class Habitat < ApplicationRecord
  has_many :geo_entity_stats
  has_one :global_change_stat
  has_many :change_stats
  has_many :species

  def global_coverage_title(habitat_type)
    habitat_type == 'points' ? "Total number of #{title.downcase} records globally" : "Total global recorded coverage of #{title.downcase}"
  end

  def protected_title
    "Percentage of #{title.downcase} that occur within a marine protected area"
  end

  def calculate_country_cover_change(country_name)
    country_cover_change = {
      change_km: 0,
      change_percentage: 0
    }

    # We only have mangroves data at the moment
    return country_cover_change unless name == 'mangroves'

    geo_entity_id = GeoEntity.find_by(name: country_name).id
    habitat_base_year = ChangeStat.find_by(
      habitat_id: id,
      geo_entity_id: geo_entity_id
    )
      &.send("total_value_#{baseline_year}".to_sym)

    habitat_last_year = ChangeStat.find_by(
      habitat_id: id,
      geo_entity_id: geo_entity_id
    )
      &.send(latest_year)

    return country_cover_change if habitat_base_year.nil? || habitat_last_year.nil?

    change_km = habitat_last_year - habitat_base_year
    change_percentage = (change_km / habitat_base_year) * 100

    country_cover_change.merge!(
      {
        change_km: ActiveSupport::NumberHelper.number_to_delimited(change_km.round(2)),
        change_percentage: change_percentage.round(2)
      }
    )
  end

  def calculate_global_cover_change
    global_cover_change = {
      change_km: 0,
      change_percentage: 0,
      baseline_year: baseline_year,
      original_total: 0
    }

    return global_cover_change unless name == 'mangroves'

    habitat_base_year = ChangeStat.includes(:geo_entity)
      .where
      .not(geo_entities: { iso3: nil })
      .where(habitat_id: id)
      .pluck("total_value_#{baseline_year}".to_sym)
      .inject(0) { |sum, x| sum + x }

    habitat_last_year = ChangeStat.includes(:geo_entity)
      .where
      .not(geo_entities: { iso3: nil })
      .where(habitat_id: id)
      .pluck(latest_year)
      .inject(0) { |sum, x| sum + x }

    total_value_change = habitat_last_year - habitat_base_year
    total_value_change_percentage = (total_value_change / habitat_base_year) * 100

    global_cover_change.merge!(
      {
        change_km: total_value_change.round(2),
        change_percentage: total_value_change_percentage.round(2),
        baseline_year: baseline_year,
        original_total: habitat_base_year.round(2)
      }
    )
  end

  def calculate_global_protection
    global_protection.except('name', 'protected_value').transform_values do |value|
      value.round(2)
    end
  end

  def occurrence(geo_entity_id)
    geo_entity_stats.find_by(geo_entity_id: geo_entity_id)&.occurrence
  end

  def baseline_year
    2010
  end

  def latest_year
    :total_value_2016
  end

  def total_value_by_country
    c = Carto.new(name)
    total_value_by_country = 0

    if name == 'coldcorals'
      total_value_by_country = c.total_points_by_country
      total_value_by_country = sort_country_count(total_value_by_country)
    else
      total_value_by_country = c.total_area_by_country
      total_value_by_country = sum_country_areas(total_value_by_country)
    end
    total_value_by_country
  end

  def type
    name == 'coldcorals' ? 'points' : 'area'
  end

  def global_stats
    stats = geo_entity_stats.country_stats.to_a # reduce hits to database
    {
      total_habitat_cover: stats.pluck(:total_value).compact.reduce(&:+),
      protected_habitat_cover: stats.pluck(:protected_value).compact.reduce(&:+)
    }
  end

  def global_protection
    stats = {
      'name' => name,
      'total_value' => 0,
      'protected_value' => 0
    }

    global_stats_data = global_stats # reduce hits to database

    stats['total_value'] = global_stats_data[:total_habitat_cover]
    stats['protected_value'] = global_stats_data[:protected_habitat_cover]

    protected_value = stats['protected_value'].positive? ? stats['protected_value'] : 1

    stats.merge({ 'protected_percentage' => protected_value / stats['total_value'] * 100 })
  end

  def self.global_protection
    all.map(&:global_protection)
  end

  def self.global_protection_by_id
    hash = {}
    global_protection.each do |habitat_stats|
      hash[habitat_stats['name']] = habitat_stats.except('name')
    end
    hash
  end

  private

  def sum_country_areas(total_area_by_country)
    country_total_area = {}
    total_area_by_country.flatten.each do |country_data|
      next if country_data['iso3'].include? '/' # remove areas which have multiple iso
      next if country_data['iso3'].include? 'ABNJ' # remove ABNJ

      country_total_area[country_data['iso3']] ||= 0
      country_total_area[country_data['iso3']] += country_data['sum']
    end
    country_total_area
  end

  def sort_country_count(total_value_by_country)
    country_total_points = {}
    total_value_by_country.each do |total_value|
      next if total_value['iso3'].include? 'ABNJ'

      country_total_points[total_value['iso3']] = total_value['count']
    end
    country_total_points
  end
end
