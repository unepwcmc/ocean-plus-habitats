class SiteController < ApplicationController
  respond_to? :json, :html
  before_action :load_habitat
  before_action :load_charts_data

  def index
    @global = YAML.load(File.open("#{Rails.root}/lib/data/content/global.yml", 'r'))

    @title = @habitat.title

    @nav = @global['nav'].to_json

    @habitatData = HabitatsSerializer.new(@habitat, @chart_greatest_coverage, @chart_protected_areas, @global).serialize

    doughnut_chart = I18n.t('home.sdg.doughnut_chart_data')
    @doughnut_chart = []

    doughnut_chart.each do |item|
      @doughnut_chart.push({
        'title': item[:title],
        'colour': item[:colour],
        'icon': ActionController::Base.helpers.image_url(item[:icon]),
        'description': item[:description],
        'url': item[:url]
      })
    end

    # respond_to do |format|
    #   format.html
    #   format.json { render json: @habitatData }
    # end
  end

  private

  def load_habitat
    @habitat = Habitat.where(name: params['habitat'] || 'warmwater').first
    @habitat ||= Habitat.where(name: 'coralreefs').first
    @habitat_type = @habitat.type
  end

  def load_charts_data

    query = <<-SQL
      SELECT DISTINCT geo_entities.id AS geo_entities_id,
                      geo_entities.iso3 AS iso3,
                      geo_entities.name AS name,
                      geo_entity_stats.total_value AS total_value

                      FROM geo_entities
                      INNER JOIN geo_entity_stats ON geo_entities.id = geo_entity_stats.geo_entity_id

                      WHERE geo_entities.iso3 IS NOT NULL

                      ORDER BY total_value DESC

                      SQL

             #GROUP BY geo_entities.id, geo_entities.iso3, geo_entities.name, geo_entity_stats.total_value

    geo_entity_stats = ActiveRecord::Base.connection.execute(query)
    # geo_entity_stats = []
    # GeoEntity.countries.each do |ge|
    #   geo_entity_stats << {
    #     geo_entity_id: ge.id,
    #     total_value: ge.geo_entity_stat&.total_value,
    #     habitat_id: habitat.id
    # }
    #   #geo_entity_stats << ge.instance_variables.each_with_object({}) { |var, hash| hash[var.to_s.delete("@")] = ge.instance_variable_get(var) }
    # end

    puts geo_entity_stats.inspect
    geo_entity_stats.first(30).each do |geo_entity_stat|
      puts geo_entity_stat.inspect
    end
    byebug
    top_five_countries = GeoEntity.countries.geo_entity_stat.where(habitat_id: @habitat.id)
                                   .order('total_value DESC')
                                   .first(5)
    arbitrary_value = top_five_countries.first.total_value.to_f * 1.05
    @chart_greatest_coverage = top_five_countries.map do |stat|
      {
        label: stat.country.name,
        value: stat.total_value.to_f.round(0),
        percent: 100*stat.total_value.to_f/arbitrary_value
      }
    end

    top_five_country_ids = top_five_countries.map(&:country_id)
    top_five_protected_areas = CountryStat.where(habitat: @habitat, country_id: top_five_country_ids)
                                         .order("protected_percentage DESC")
                                         .first(5)

    @chart_protected_areas = top_five_protected_areas.map do |stat|
      {
        label: stat.country.name,
        percent: stat.protected_percentage.to_f.round(1),
      }
    end
  end
end
