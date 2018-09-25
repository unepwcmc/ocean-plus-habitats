class SiteController < ApplicationController
  before_action :load_global

  def warmwater
    @title = 'Warm-water corals'
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
