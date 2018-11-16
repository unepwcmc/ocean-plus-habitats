class SiteController < ApplicationController
  before_action :load_habitat
  before_action :load_global
  before_action :load_charts_data

  def warmwater
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/warmwater.yml", 'r'))

    @commitments = [
      @aichi_targets,
      @sdgs,
      @data['other_targets']
    ]
  end

  def saltmarshes
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/saltmarshes.yml", 'r'))

    @commitments = [
      @aichi_targets,
      @sdgs,
      @data['other_targets']
    ]
  end

  def mangroves
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/mangroves.yml", 'r'))

    @commitments = [
      @aichi_targets,
      @sdgs,
      @data['other_targets']
    ]
  end

  def seagrasses
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/seagrasses.yml", 'r'))

    @commitments = [
      @aichi_targets,
      @sdgs,
      @data['other_targets']
    ]
  end

  def coldcorals
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/coldwater.yml", 'r'))

    @commitments = [
      @aichi_targets,
      @sdgs,
      @data['other_targets']
    ]
  end

  private

  def load_habitat
    @habitat = Habitat.where(name: action_name).first
    @habitat ||= Habitat.where(name: 'coralreef').first
    @habitat_type = @habitat.type
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
      {
        label: label,
        value: country.last.round(0),
        percent: 100*country.last/arbitrary_value
      }
    end

    top_five_country_ids = top_five_countries.map do |country|
      iso3 = country.first
      country_id = Country.find_by(iso3: country.first).id
      country_id
    end

    top_five_protected_areas = StaticStat.where(habitat: @habitat, country_id: top_five_country_ids).order("protected_percentage DESC").pluck(:country_id, :protected_percentage).to_a.first(5)

    @chart_protected_areas = top_five_protected_areas.map do |country|
      label = Country.find(country.first).name
      {
        label: label,
        percent: country.last.round(1),
      }
    end
  end
end
