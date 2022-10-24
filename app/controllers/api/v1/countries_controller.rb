class Api::V1::CountriesController < Api::V1::BaseController
  before_action :set_country, only: [:show]

  def show
    render json: @country.as_json(
      only: %i[name iso3],
      methods: [:protected_area_statistics]
    )
  end

  def index
    @countries = GeoEntity.countries
      .eager_load(geo_entity_stats: :habitat)

    render json: @countries.as_json(
      only: %i[name iso3],
      methods: [:protected_area_statistics]
    )
  end

  private

  def set_country
    @country = GeoEntity.countries
      .includes(geo_entity_stats: :habitat)
      .find_by(iso3: params[:iso3])
  end
end