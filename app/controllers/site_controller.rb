class SiteController < ApplicationController
  respond_to? :json, :html
  before_action :load_habitat
  before_action :load_global
  before_action :load_charts_data

  def index
    @title = @habitat.title

    @nav = [
      {
        name: 'warmwater',
        title: 'Warm-water corals'
      },
      {
        name: 'saltmarshes',
        title: 'Saltmarshes'
      },
      {
        name: 'mangroves',
        title: 'Mangroves'
      },
      {
        name: 'seagrasses',
        title: 'Seagrasses'
      },
      {
        name: 'coldcorals',
        title: 'Cold-water corals'
      }
    ].to_json

    content = YAML.load(File.open("#{Rails.root}/lib/data/content/#{@habitat.name}.yml", 'r'))

    @habitatData = {
      name: @habitat.name,
      theme: @habitat.theme,
      nav: {

      },
      content: content,
      map: {
        habitatTitle: @habitat.title,
        habitatType: @habitat_type,
        theme: @habitat.theme,
        tables: [@habitat.poly_table, @habitat.point_table].compact,
        titleGlobal: @habitat.global_coverage_title(@habitat_type),
        titleProtected: @habitat.protected_title,
        percentageGlobal: @habitat.global_coverage,
        percentageProtected: @habitat.protected_percentage,
        wmsUrl: @habitat.wms_url
      },
      columnChart: @chart_greatest_coverage,
      rowChart: @chart_protected_areas,
      disclaimer: @global['disclaimer'],
      commitments: [
        @aichi_targets, 
        @sdgs,
        content['other_targets'] 
      ]
    }.to_json

    respond_to do |format|
      format.html
      format.json { render json: @habitatData }
    end
  end

  private

  def load_habitat
    @habitat = Habitat.where(name: params['habitat'] || 'warmwater').first
    @habitat ||= Habitat.where(name: 'coralreef').first
    @habitat_type = @habitat.type
  end

  def load_global
    @global = YAML.load(File.open("#{Rails.root}/lib/data/content/global.yml", 'r'))
    @aichi_targets = YAML.load(File.open("#{Rails.root}/lib/data/content/aichi-targets.yml", 'r'))
    @sdgs = YAML.load(File.open("#{Rails.root}/lib/data/content/sdgs.yml", 'r'))
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
