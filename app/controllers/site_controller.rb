class SiteController < ApplicationController
  before_action :load_global

  def warmwater
    
  end

  def saltmarshes
  end

  def mangroves
  end

  def seagrasses
  end

  def coldwater
  end

  private
    def load_global
      @global = YAML.load(File.open("#{Rails.root}/lib/data/content/global.yml", 'r'))
    end
  
end
