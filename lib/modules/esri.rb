class Esri 
  include HTTParty

  def initialize
    esri_server_url = Rails.application.secrets.dig(:esri_server_eez_url)
    @url = self.class.base_uri("#{esri_server_url}/FeatureServer/0/query")
  end

  def fetch_bounding_box(iso3)
    options = { where: "iso_ter = '#{iso3}'", returnExtentOnly: true, f: 'pjson', outSR: 4326 }
    response = self.class.post(@url, query: options)
    
    # Response returned includes a 'spatialReference' key for the coordinates
    JSON.parse(response.parsed_response)['extent'].except('spatialReference')
  end
end