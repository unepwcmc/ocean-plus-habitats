class Habitat < ApplicationRecord

  has_many :geo_entity_stats
  has_many :change_stats

  def global_coverage_title(habitat_type)
    habitat_type == 'points' ? "Total number of #{title.downcase} records globally" : "Total global recorded coverage of #{title.downcase}"
  end

  def protected_title
    "Percentage of #{title.downcase} that occur within a marine protected area"
  end

  # def calculate_global_coverage
  #   # coverage = Carto.new(name).total_area.first['sum']
  #   # update_attributes(global_coverage: coverage.round)


  #   query = <<-SQL
  #     SELECT geo_entities.id AS geo_entities_id,
  #            geo_entities.iso3 AS iso3,
  #            geo_entities.name AS geo_entities_name,
  #            geo_entity_stats.habitat_id as habitat_id,
  #            geo_entity_stats.total_value AS total_value,
  #            SUM(geo_entity_stats.total_value) AS sum_total_value

  #            FROM geo_entities
  #            INNER JOIN geo_entity_stats ON geo_entities.id = geo_entity_stats.geo_entity_id
  #            INNER JOIN habitats ON habitats.id = geo_entity_stats.habitat_id
  #            WHERE geo_entities.iso3 IS NOT NULL
  #            AND habitat_id = #{self.id}
  #            GROUP BY sum_total_value

  #            SQL

  #   geo_entity_stats = ActiveRecord::Base.connection.execute(query)

  #   puts geo_entity_stats.inspect
  #   geo_entity_stats.first(5).each do |geo_entity_stat|
  #     puts geo_entity_stat.inspect
  #   end
  # end

  def calculate_global_cover_change
    query = <<-SQL
      SELECT geo_entities.id AS geo_entities_id,
             geo_entities.iso3 AS iso3,
             geo_entities.name AS geo_entities_name,
             change_stats.habitat_id AS habitat_id,
             SUM(change_stats.total_value_2010) - SUM(change_stats.total_value_1996) AS total_value_change

             FROM geo_entities
             INNER JOIN change_stats ON geo_entities.id = change_stats.geo_entity_id
             INNER JOIN habitats ON habitats.id = change_stats.habitat_id
             WHERE geo_entities.iso3 IS NOT NULL
             AND habitat_id = #{self.id}
             GROUP BY geo_entities_id, habitat_id
             ORDER BY total_value_change DESC

             SQL

    geo_entity_stats = ActiveRecord::Base.connection.execute(query)

    puts geo_entity_stats.inspect
    geo_entity_stats.first(5).each do |geo_entity_stat|
      puts geo_entity_stat.inspect
    end
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
