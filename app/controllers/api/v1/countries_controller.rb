PER_PAGE = 25.freeze

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
    res = {
      metadata: index_metadata,
      records: countries_as_json
    }

    render json: res
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
      .paginate(page: page, per_page: PER_PAGE)
      .eager_load(geo_entity_stats: :habitat)
  end

  def countries_as_json
    @countries.as_json(
      only: %i[name iso3],
      methods: %i[protected_area_statistics]
    )
  end

  def index_metadata
    {
      page: page,
      per_page: PER_PAGE,
      page_count: page_count,
      total_count: total_count
    }
  end

  def page
    params[:page] || 1
  end

  def total_count
    @total_count ||= @countries.count
  end

  def page_count
    (total_count.to_f / PER_PAGE).ceil
  end
end
