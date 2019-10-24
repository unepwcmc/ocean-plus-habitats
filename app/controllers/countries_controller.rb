class CountriesController < ApplicationController
  def index
  end

  def show
    @country = Country.find(params[:id])

    @yml_key = @country[:iso3].downcase
  end
end
