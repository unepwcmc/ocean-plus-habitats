require 'rails_helper'

RSpec.describe Api::V1::CountriesController, type: :controller do
  describe 'GET #show' do
    let!(:country) { create_list(:country, 2) }

    it 'returns summary data for a country' do
      get :show, params: { iso3: country.first.iso3 }, format: :json
      expect(response).to be_successful

      response_body = JSON.parse(response.body)
      expect(response_body['iso3']).to match(country.first.iso3)
    end
  end

  describe 'GET #index' do
    let!(:country) { create_list(:country, 2) }
  
    it 'returns summary data for countries' do
      get :index, format: :json
      expect(response).to be_successful
      
      response_body = JSON.parse(response.body)
      expect(response_body['records'].pluck('iso3')).to match(GeoEntity.pluck(:iso3))
      expect(response_body['metadata']).to eq({
        'page' => 1,
        'per_page' => 25,
        'page_count' => 1,
        'total_count' => 2
      })
    end
  end
end
