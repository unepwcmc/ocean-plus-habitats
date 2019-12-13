class SiteController < ApplicationController
  def index
    @global = YAML.load(File.open("#{Rails.root}/lib/data/content/global.yml", 'r'))

    @nav_tertiary = I18n.t('home.nav_sticky').to_json

    @habitats = I18n.t('global.habitats')

    @habitat_change_modal = { title: 'Title hardcoded in controller', text: I18n.t('home.habitat_change.citation') }.to_json

    @red_list_categories = I18n.t('home.red_list.categories')
    red_list_data = Species.count_species

    @red_list_data = @habitats.each { |habitat| habitat['data'] = red_list_data[habitat[:id]] }
    @red_list_modal = { title: 'Title hardcoded in controller', text: I18n.t('home.red_list.citation') }.to_json

    @habitat_cover = Serializers::HabitatCoverSerializer.new.serialize
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
end
