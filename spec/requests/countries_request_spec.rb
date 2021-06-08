require 'rails_helper'

RSpec.describe 'Countries', type: :request do
  include_context 'countries_setup'

  before do
    allow(GeoEntity).to receive(:permitted_countries).and_return(GeoEntity.all)
    country
    many_species
  end

  describe 'GET /:country' do
    it 'gets the index page' do
      # Possibly flaky spec - test setup always creates multiple Countries
      # and the only country which has any stats associated with it is the last to 
      # be created
      kebabcase_name = GeoEntity.last.name.downcase.gsub(' ', '-')

      get "/#{kebabcase_name}"

      expect(response).to be_successful
      expect(response.content_type).to eq('text/html')
    end
  end
end
