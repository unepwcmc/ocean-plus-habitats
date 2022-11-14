class Api::V1::RegionsController < Api::V1::BaseController
  before_action :set_regions, only: [:index]

  def index
    render json: @regions.as_json(
      only: %i[name],
      methods: %i[
        protected_area_statistics
        species_status
        mangrove_change_statistics
      ]
    )
  end

  private

  def set_regions
    @regions = GeoEntity.regions
      .order(name: :asc)
      .eager_load(
        :change_stat,
        :countries,
        [:country_relationship],
        [:geo_entities_species],
        [:species],
        geo_entity_stats: [:habitat]
      )
  end
end
