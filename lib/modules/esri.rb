class Esri 
  include HTTParty

  def initialize
    esri_server_url = Rails.application.secrets.dig(:esri_server_eez_url)
    @url = self.class.base_uri("#{esri_server_url}/FeatureServer/0/query")
  end

  def fetch_bounding_box(iso3)
    options = { where: "iso_ter = '#{iso3}'", returnExtentOnly: true, f: 'pjson', outSR: 4326 }

    retries = 0

    # ESRI is flaky
    begin
      response = self.class.post(@url, query: options)
    rescue Net::OpenTimeout 
      retries += 1
      retry if retries < 2
    end

    # Response returned includes a 'spatialReference' key for the coordinates
    JSON.parse(response.parsed_response)['extent'].except('spatialReference')
  end
end