class Carto
  include HTTParty

  attr_reader :response

  def initialize(habitat, constraints=nil)
    @habitat = Habitat.find_by_name(habitat)
    @constraints = constraints
    carto_username = Rails.application.secrets.dig(:carto_username)
    self.class.base_uri "https://#{carto_username}.carto.com/api/v2"
  end

  def total_area
    carto_api_key = Rails.application.secrets.dig(:carto_api_key)
    @options = { query: { q: total_area_query, api_key: carto_api_key } }
    @response = self.class.get("/sql", @options)
    @response.parsed_response['rows']
  end

  def total_area_by_country
    carto_api_key = Rails.application.secrets.dig(:carto_api_key)
    @options = { query: { q: total_area_by_country_query, api_key: carto_api_key } }
    @response = self.class.get("/sql", @options)
    @response.parsed_response['rows']
  end

  def intersect
    @response = self.class.get("/sql", @options)
    @response.parsed_response['rows']
  end

  private

  def total_area_query
    query = "SELECT SUM(gis_area_k) FROM #{from}"
    query << " WHERE #{@constraints}" if @constraints.present?
    query
  end

  def total_area_by_country_query
    query = "SELECT SUM(gis_area_k),iso3 FROM #{from} GROUP BY iso3 ORDER by SUM(gis_area_k) desc"
    query
  end

  def from
    @habitat.poly_table
  end

  def intersection
    PostgisUtils.intersection(@geom)
  end
end
