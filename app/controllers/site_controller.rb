class SiteController < ApplicationController
  before_action :load_global
  before_action :load_charts_data

  def warmwater
    @title = 'Warm-water corals'
    @theme = 'orange'
    @global_coverage_title = global_coverage_title
    @protected_title = protected_title
    @global_coverage = 0 #TODO
    @protected_percentage = 0 #TODO

    @commitments = [
      @aichi_targets,
      @sdgs,
      @sdgs = YAML.load(File.open("#{Rails.root}/lib/data/content/meas-warmwater.yml", 'r'))
    ]
  end

  def saltmarshes
    @title = 'Saltmarshes'
    @theme = 'green'
    @global_coverage_title = global_coverage_title
    @protected_title = protected_title
    @global_coverage = 0 #TODO
    @protected_percentage = 0 #TODO

    @commitments = [
      @aichi_targets,
      @sdgs,
      @sdgs = YAML.load(File.open("#{Rails.root}/lib/data/content/meas-saltmarshes.yml", 'r'))
    ]
  end

  def mangroves
    @title = 'Mangroves'
    @theme = 'yellow'
    @global_coverage_title = global_coverage_title
    @protected_title = protected_title
    @global_coverage = 0 #TODO
    @protected_percentage = 0 #TODO

    @commitments = [
      @aichi_targets,
      @sdgs,
      @sdgs = YAML.load(File.open("#{Rails.root}/lib/data/content/meas-mangroves.yml", 'r'))
    ]
  end

  def seagrasses
    @title = 'Seagrasses'
    @theme = 'blue'
    @global_coverage_title = global_coverage_title
    @protected_title = protected_title
    @global_coverage = 0 #TODO
    @protected_percentage = 0 #TODO

    @commitments = [
      @aichi_targets,
      @sdgs,
      @sdgs = YAML.load(File.open("#{Rails.root}/lib/data/content/meas-seagrasses.yml", 'r'))
    ]
  end

  def coldwater
    @title = 'Cold-water corals'
    @theme = 'pink'
    @global_coverage_title = global_coverage_title
    @protected_title = protected_title
    @global_coverage = 0 #TODO
    @protected_percentage = 0 #TODO

    @commitments = [
      @aichi_targets,
      @sdgs,
      @sdgs = YAML.load(File.open("#{Rails.root}/lib/data/content/meas-coldwater.yml", 'r'))
    ]
  end

  private

  def load_global
    @global = YAML.load(File.open("#{Rails.root}/lib/data/content/global.yml", 'r'))
    @aichi_targets = YAML.load(File.open("#{Rails.root}/lib/data/content/aichi-targets.yml", 'r'))
    @sdgs = YAML.load(File.open("#{Rails.root}/lib/data/content/sdgs.yml", 'r'))
  end

  def load_charts_data
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

  def global_coverage_title
    "Total global coverage of #{@title.downcase}"
  end

  def protected_title
    "Percentage of #{@title.downcase} that occur within a marine protected area"
  end
end