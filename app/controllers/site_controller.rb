class SiteController < ApplicationController
  before_action :load_habitat
  before_action :load_global
  before_action :load_charts_data

  def warmwater
    @commitments = [
      @aichi_targets,
      @sdgs,
      @sdgs = YAML.load(File.open("#{Rails.root}/lib/data/content/meas-warmwater.yml", 'r'))
    ]
  end

  def saltmarshes
    @commitments = [
      @aichi_targets,
      @sdgs,
      @sdgs = YAML.load(File.open("#{Rails.root}/lib/data/content/meas-saltmarshes.yml", 'r'))
    ]
  end

  def mangroves
    @commitments = [
      @aichi_targets,
      @sdgs,
      @sdgs = YAML.load(File.open("#{Rails.root}/lib/data/content/meas-mangroves.yml", 'r'))
    ]
  end

  def seagrasses
    @commitments = [
      @aichi_targets,
      @sdgs,
      @sdgs = YAML.load(File.open("#{Rails.root}/lib/data/content/meas-seagrasses.yml", 'r'))
    ]
  end

  def coldwater
    @commitments = [
      @aichi_targets,
      @sdgs,
      @sdgs = YAML.load(File.open("#{Rails.root}/lib/data/content/meas-coldwater.yml", 'r'))
    ]
  end

  private

  def load_habitat
    @habitat = Habitat.where(name: action_name).first
    @habitat ||= Habitat.where(name: 'coralreef').first
  end

  def load_global
    @global = YAML.load(File.open("#{Rails.root}/lib/data/content/global.yml", 'r'))
    @aichi_targets = YAML.load(File.open("#{Rails.root}/lib/data/content/aichi-targets.yml", 'r'))
    @sdgs = YAML.load(File.open("#{Rails.root}/lib/data/content/sdgs.yml", 'r'))
  end

  def calculate_percentage(global_area, country_total_area)
    percentage_total_area = {}
    country_total_area
  end

  def calculate_global_area(global_area)
    total = 0.0
    global_area.each do |global_area_habitat|
      total = total + global_area_habitat.first["sum"].to_f
    end
    total
  end

  def sum_country_areas(habitat_data, country_total_area)
    habitat_data.flatten.each do |country_data|
      next if country_data["iso3"].include? "/" # remove areas which are multiple iso
      country_total_area[country_data["iso3"]] = country_total_area[country_data["iso3"]].nil? ?  country_data["sum"] : country_total_area[country_data["iso3"]] + country_data["sum"]
    end
    country_total_area
  end

  def load_charts_data
    habitat_data = []
    global_area = []
    Habitat.all.each do |habitat|
      c = Carto.new(habitat.name)
      habitat_data << c.total_area_by_country
      global_area << c.total_area
    end

    country_total_area = {}

    country_total_area = sum_country_areas(habitat_data, country_total_area)
    global_area = calculate_global_area(global_area)
    country_total_area_percentage = calculate_percentage(global_area, country_total_area)

    byebug
    country_total_area_percentage.sort_by {|_key, value| value}
    byebug

    @chart_greatest_coverage = [
      {
        label: 'Australia',
        value: '94',
        percent: '94',
      },
      {
        label: 'United Kingdom',
        value: '63',
        percent: '63',
      },
      {
        label: 'Spain',
        value: '75',
        percent: '75',
      },
      {
        label: 'Italy',
        value: '50',
        percent: '50',
      },
      {
        label: 'Russia',
        value: '10',
        percent: '10',
      }
    ]

    @chart_protected_areas = [
      {
        label: 'Australia',
        percent: '94',
      },
      {
        label: 'United Kingdom',
        percent: '63',
      },
      {
        label: 'Spain',
        percent: '75',
      },
      {
        label: 'Italy',
        percent: '50',
      },
      {
        label: 'Russia',
        percent: '10',
      }
    ]
  end
end
