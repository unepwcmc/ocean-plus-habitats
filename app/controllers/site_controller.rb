class SiteController < ApplicationController
  respond_to? :json, :html
  before_action :load_habitat

  def index
    @global = YAML.load(File.open("#{Rails.root}/lib/data/content/global.yml", 'r'))

    @title = @habitat.title

    @habitatData = HabitatsSerializer.new(@habitat, @chart_greatest_coverage, @chart_protected_areas, @global).serialize
    @habitats = I18n.t('global.habitats')

    @habitat_change_modal = { title: 'Title hardcoded in controller', text: I18n.t('home.habitat_change.citation') }.to_json

    @red_list_categories = I18n.t('home.red_list.categories')
    red_list_data = [[1,2,3,4,5,6,7, 28],[1,2,3,4,5,6,7, 28],[1,2,3,4,5,6,7, 28],[1,2,3,4,5,6,7, 28],[1,2,3,4,5,6,7, 28],[1,2,3,4,5,6,7, 28],[1,2,3,4,5,6,7, 28]] #FERDI NOTE THE TOTAL AT THE END

    @red_list_data = @habitats.zip(red_list_data)
    @red_list_modal = { title: 'Title hardcoded in controller', text: I18n.t('home.red_list.citation') }.to_json

    @habitat_cover = HabitatCoverSerializer.new.serialize
    @habitat_cover_modal = { title: 'Title hardcoded in controller', text: I18n.t('home.habitat_cover.citation') }.to_json

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

  private

  def load_habitat
    @habitat = Habitat.where(name: params['habitat'] || 'warmwater').first
    @habitat ||= Habitat.where(name: 'coralreefs').first
    @habitat_type = @habitat.type
  end
end
