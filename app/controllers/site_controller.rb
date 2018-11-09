class SiteController < ApplicationController
  before_action :load_global
  before_action :load_charts_data

  def warmwater
    @title = 'Warm-water corals'
    @global_coverage_title = global_coverage_title
    @protected_title = protected_title
    @global_coverage = 0 #TODO
    @protected_percentage = 0 #TODO
  end

  def saltmarshes
    @title = 'Saltmarshes'
    @global_coverage_title = global_coverage_title
    @protected_title = protected_title
    @global_coverage = 0 #TODO
    @protected_percentage = 0 #TODO
  end

  def mangroves
    @title = 'Mangroves'
    @global_coverage_title = global_coverage_title
    @protected_title = protected_title
    @global_coverage = 0 #TODO
    @protected_percentage = 0 #TODO
  end

  def seagrasses
    @title = 'Seagrasses'
    @global_coverage_title = global_coverage_title
    @protected_title = protected_title
    @global_coverage = 0 #TODO
    @protected_percentage = 0 #TODO
  end

  def coldwater
    @title = 'Cold-water corals'
    @global_coverage_title = global_coverage_title
    @protected_title = protected_title
    @global_coverage = 0 #TODO
    @protected_percentage = 0 #TODO
  end

  private

  def load_global
    @global = YAML.load(File.open("#{Rails.root}/lib/data/content/global.yml", 'r'))
    @commitments = YAML.load(File.open("#{Rails.root}/lib/data/content/commitments.yml", 'r'))
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
