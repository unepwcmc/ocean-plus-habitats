class SiteController < ApplicationController
  before_action :load_global

  def warmwater
    @title = 'Warm-water corals'
    @chart_greatest_coverage = [
      {
        label: 'Australia',
        value: '24',
        percent: '24',
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
  end

  def saltmarshes
    @title = 'Saltmarshes'
  end

  def mangroves
    @title = 'Mangroves'
  end

  def seagrasses
    @title = 'Seagrasses'
  end

  def coldwater
    @title = 'Cold-water corals'
  end

  private
    def load_global
      @global = YAML.load(File.open("#{Rails.root}/lib/data/content/global.yml", 'r'))
    end
  
end
