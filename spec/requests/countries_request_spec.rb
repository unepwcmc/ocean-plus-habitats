require 'rails_helper'

RSpec.describe 'Countries', type: :request do
  include_context 'countries_setup'

  let(:headers) { { "Accept": 'application/json' } }

  before do
    country
    many_species
  end

  describe 'GET /:country' do
    it 'gets the index page' do
      # Possibly flaky spec - test setup always creates multiple Countries
      kebabcase_name = GeoEntity.last.name.downcase.gsub(' ', '-')

      get "/#{kebabcase_name}"

      expect(response).to be_successful
      expect(response.content_type).to eq('text/html')
    end
  end
end
