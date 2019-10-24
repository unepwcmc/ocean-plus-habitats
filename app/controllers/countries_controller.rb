class CountriesController < ApplicationController
  def index
  end

  def show
    @country = Country.find(params[:id])
  end
end
