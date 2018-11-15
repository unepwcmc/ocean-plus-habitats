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

  def coldcorals
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

  def load_charts_data

    top_five_countries = @habitat.total_value_by_country.sort_by {|_key, value| value}.last(5)
    arbitrary_value = top_five_countries.last.last.to_f * 1.05

    @chart_greatest_coverage = top_five_countries.reverse.map do |country|
      label = Country.find_by(iso3: country.first).name
      type = @habitat.name == "coldcorals" ? "points" : "area"
      {
        label: label,
        type: type,
        value: country.last.round(0),
        percent: 100*country.last/arbitrary_value
      }
    end

    top_five_protected_areas = StaticStat.where(habitat: @habitat).order("protected_percentage DESC").pluck(:country_id, :protected_percentage).to_a.first(5)

    @chart_protected_areas = top_five_protected_areas.map do |country|
      label = Country.find(country.first).name
      {
        label: label,
        percent: country.last.round(1),
      }
    end
  end
end
