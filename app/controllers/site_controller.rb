class SiteController < ApplicationController
  def index
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/global.yml", 'r'))
  end
end
