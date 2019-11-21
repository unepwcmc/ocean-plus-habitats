class Habitat < ApplicationRecord

  has_many :geo_entity_stats
  has_many :change_stats

  def global_coverage_title(habitat_type)
    habitat_type == 'points' ? "Total number of #{title.downcase} records globally" : "Total global recorded coverage of #{title.downcase}"
  end

  def protected_title
    "Percentage of #{title.downcase} that occur within a marine protected area"
  end

  def calculate_country_cover_change(iso3)
    country_cover_change = { change_km: 0, change_percentage: 0 }
    return country_cover_change unless name == "mangroves"
    geo_entity_id = GeoEntity.find_by(iso3: iso3).id
    habitat_base_year = ChangeStat.find_by(habitat_id: id, geo_entity_id: geo_entity_id).send(baseline_year)
    habitat_last_year = ChangeStat.find_by(habitat_id: id, geo_entity_id: geo_entity_id).total_value_2016
    return country_cover_change if (habitat_base_year.nil? || habitat_last_year.nil?)
    change_km = habitat_last_year - habitat_base_year
    change_percentage = (change_km/habitat_base_year) * 100
    
    country_cover_change.merge!({change_km: change_km.round(2), change_percentage: change_percentage.round(2)})
  end

  def calculate_global_cover_change
    return global_cover_change = {
      change_km: 0,
      change_percentage: 0,
      baseline_total: 0
    } unless name == "mangroves"
    habitat_base_year = ChangeStat.where(habitat_id: id).pluck(:total_value_2010).inject(0) { |sum, x| sum + x }
    habitat_last_year = ChangeStat.where(habitat_id: id).pluck(:total_value_2016).inject(0) { |sum, x| sum + x }
    total_value_change = habitat_last_year - habitat_base_year
    total_value_change_percentage = (total_value_change / habitat_base_year) * 100

    global_cover_change = {
      change_km: total_value_change.round(2),
      change_percentage: total_value_change_percentage.round(2),
      baseline_total: habitat_base_year.round(2)
    }
    global_cover_change
  end

  def baseline_year
    :total_value_2010
  end

  def total_value_by_country
    c = Carto.new(name)
    total_value_by_country = 0

    if name == "coldcorals"
      total_value_by_country = c.total_points_by_country
      total_value_by_country = sort_country_count(total_value_by_country)
    else
      total_value_by_country = c.total_area_by_country
      total_value_by_country = sum_country_areas(total_value_by_country)
    end
    total_value_by_country
  end

  def type
    name == "coldcorals" ? "points" : "area"
  end

  private

  def sum_country_areas(total_area_by_country)
    country_total_area = {}
    total_area_by_country.flatten.each do |country_data|
      next if country_data["iso3"].include? "/" #remove areas which have multiple iso
      next if country_data["iso3"].include? "ABNJ" #remove ABNJ
      country_total_area[country_data["iso3"]] ||= 0
      country_total_area[country_data["iso3"]] += country_data["sum"]
    end
    country_total_area
  end

  def sort_country_count(total_value_by_country)
    country_total_points = {}
    total_value_by_country.each do |total_value|
      next if total_value["iso3"].include? "ABNJ"
      country_total_points[total_value["iso3"]] = total_value["count"]
    end
    country_total_points
  end
end
