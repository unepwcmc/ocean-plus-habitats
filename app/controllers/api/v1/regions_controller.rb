class Api::V1::RegionsController < Api::V1::BaseController
  before_action :set_regions, only: [:index]
  before_action :set_region, only: [:show]

  def index
    render json: @regions.as_json(only: %i[id name])
  end

  def show
    region_json = @region.as_json(
      only: %i[id name],
      methods: [
        :ordered_countries,
        :protected_area_statistics,
        :habitat_change_statistics,
        :species_status
      ]
    )

    region_json['countries'] = region_json.delete('ordered_countries')

    render json: region_json
  end

  private

  def set_regions
    @regions = GeoEntity.regions.order(name: :asc)
  end

  def set_region
    @region = GeoEntity.regions.find(params[:id])
  end
end
