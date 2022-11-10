class Api::V1::CountriesController < Api::V1::BaseController
  before_action :set_country, only: [:show]
  before_action :set_countries, only: [:index]

  def show
    render json: @country.as_json(
      only: %i[name iso3],
      methods: %i[protected_area_statistics species_status]
    )
  end

  def index
    render json: @countries.as_json(
      only: %i[name iso3],
      methods: %i[protected_area_statistics]
    )
  end

  private

  def set_country
    @country = GeoEntity.countries
      .includes(geo_entity_stats: :habitat)
      .find_by(iso3: params[:iso3])
  end

  def set_countries
    @countries = GeoEntity.countries
      .order(name: :asc)
      .paginate(page: params[:page] || 1, per_page: 25)
      .eager_load(geo_entity_stats: :habitat)
  end
end
