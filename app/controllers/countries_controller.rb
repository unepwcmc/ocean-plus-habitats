class CountriesController < ApplicationController
  def index
  end

  def show
    @country = GeoEntity.find_by(iso3: params[:id])

    @yml_key = @country[:iso3].downcase
  end
end
