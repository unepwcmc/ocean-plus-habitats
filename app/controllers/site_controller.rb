class SiteController < ApplicationController
  respond_to? :json, :html
  before_action :load_habitat

  def index
    @global = YAML.load(File.open("#{Rails.root}/lib/data/content/global.yml", 'r'))

    @title = @habitat.title

    @habitatData = HabitatsSerializer.new(@habitat, @chart_greatest_coverage, @chart_protected_areas, @global).serialize
    
    @habitats = I18n.t('global.habitats')

  #   query = <<-SQL
  #   SELECT DISTINCT geo_entities.id AS geo_entities_id,
  #                   geo_entities.iso3 AS iso3,
  #                   geo_entities.name AS name,
  #                   geo_entity_stats.habitat_id as habitat_id,
  #                   geo_entity_stats.total_value AS total_value

  #                   FROM geo_entities
  #                   INNER JOIN geo_entity_stats ON geo_entities.id = geo_entity_stats.geo_entity_id
  #                   INNER JOIN habitats ON habitats.id = geo_entity_stats.habitat_id
  #                   WHERE geo_entities.iso3 IS NOT NULL
  #                   AND habitat_id = #{@habitat.id}
  #                   ORDER BY total_value DESC

  #                   SQL

  #          #GROUP BY geo_entities.id, geo_entities.iso3, geo_entities.name, geo_entity_stats.total_value

  # geo_entity_stats = ActiveRecord::Base.connection.execute(query)

  # puts geo_entity_stats.inspect
  # geo_entity_stats.first(5).each do |geo_entity_stat|
  #   puts geo_entity_stat.inspect
  # end
  # top_five_countries = geo_entity_stats.first(5)
  # # top_five_countries = GeoEntity.countries.geo_entity_stat.where(habitat_id: @habitat.id)
  # #                                .order('total_value DESC')
  # #                                .first(5)
  # arbitrary_value = top_five_countries.first["total_value"].to_f * 1.05
  # @chart_greatest_coverage = top_five_countries.map do |stat|
  #   {
  #     label: stat["name"],
  #     value: stat["total_value"].to_f.round(0),
  #     percent: 100*stat["total_value"].to_f/arbitrary_value
  #   }
  # end

    #----------------------------------------------------------------------------#
    # FERDI variables will need adding to this object ---------------------------#
    # https://guides.rubyonrails.org/i18n.html#passing-variables-to-translations #
    @habitat_cover = I18n.t('home.habitat_cover.habitats')
    #----------------------------------------------------------------------------#

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

    @red_list_categories = I18n.t('home.red_list.categories')
    red_list_data = [[1,2,3,4,5,6,7, 28],[1,2,3,4,5,6,7, 28],[1,2,3,4,5,6,7, 28],[1,2,3,4,5,6,7, 28],[1,2,3,4,5,6,7, 28],[1,2,3,4,5,6,7, 28],[1,2,3,4,5,6,7, 28]] #FERDI NOTE THE TOTAL AT THE END

    @red_list_data = @habitats.zip(red_list_data)
  end

  private

  def load_habitat
    @habitat = Habitat.where(name: params['habitat'] || 'warmwater').first
    @habitat ||= Habitat.where(name: 'coralreefs').first
    @habitat_type = @habitat.type
  end
end
