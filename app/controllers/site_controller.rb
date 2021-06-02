class SiteController < ApplicationController
  include ApplicationHelper

  def index
    @habitats = habitats

    @map_datasets = Serializers::MapDatasetsSerializer.new(Habitat.global_protection_by_id).serialize
    @map_datasets_habitats = @map_datasets.reject { |d| %w[wdpa oecm].include?(d[:id]) }

    @eez_map_datasets = Serializers::EezMapDatasetsSerializer.new.serialize

    red_list_data = Species.count_species

    @red_list_data = @habitats.each { |habitat| habitat['data'] = red_list_data[habitat[:id]] }

    @habitat_cover = Serializers::HabitatCoverSerializer.new.serialize

    doughnut_chart = I18n.t('home.sdg.doughnut_chart_data')
    @doughnut_chart = []

    doughnut_chart.each do |item|
      @doughnut_chart.push({
        'title': item[:title],
        'colour': item[:colour],
        'icon': ActionController::Base.helpers.image_url(item[:icon]),
        'description': item[:description],
        'url': item[:url],
        'source': item[:source]
      })
    end
  end

  def about
  end

  def methodologies
  end
end
