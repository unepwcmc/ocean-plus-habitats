class SiteController < ApplicationController
  respond_to? :json, :html
  before_action :load_habitat
  before_action :load_charts_data

  def index
    @global = YAML.load(File.open("#{Rails.root}/lib/data/content/global.yml", 'r'))

    @title = @habitat.title

    @habitatData = HabitatsSerializer.new(@habitat, @chart_greatest_coverage, @chart_protected_areas, @global).serialize
    
    @habitats = I18n.t('global.habitats')

    #----------------------------------------------------------------------------#
    # FERDI variables will need adding to this object ---------------------------#
    # https://guides.rubyonrails.org/i18n.html#passing-variables-to-translations #
    habitat_cover = I18n.t('home.habitat_cover.habitats')
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
    red_list_data = [[1,2,3,4,5,6,7],[1,2,3,4,5,6,7],[1,2,3,4,5,6,7],[1,2,3,4,5,6,7],[1,2,3,4,5,6,7],[1,2,3,4,5,6,7],[1,2,3,4,5,6,7]]

    @red_list_data = @habitats.zip(red_list_data)
  end

  private

  def load_habitat
    @habitat = Habitat.where(name: params['habitat'] || 'warmwater').first
    @habitat ||= Habitat.where(name: 'coralreef').first
    @habitat_type = @habitat.type
  end

  def load_charts_data
    top_five_countries = StaticStat.where(habitat_id: @habitat.id)
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
    top_five_protected_areas = StaticStat.where(habitat: @habitat, country_id: top_five_country_ids)
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
