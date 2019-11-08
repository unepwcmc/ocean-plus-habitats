class Habitat < ApplicationRecord

  has_many :geo_entity_stats
  has_many :change_stats

  def global_coverage_title(habitat_type)
    habitat_type == 'points' ? "Total number of #{title.downcase} records globally" : "Total global recorded coverage of #{title.downcase}"
  end

  def protected_title
    "Percentage of #{title.downcase} that occur within a marine protected area"
  end

  def calculate_global_coverage
    coverage = Carto.new(name).total_area.first['sum']
    update_attributes(global_coverage: coverage.round)
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
