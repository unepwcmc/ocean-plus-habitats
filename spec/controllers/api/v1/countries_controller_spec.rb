require 'rails_helper'

DEFAULT_PER_PAGE = 25
INDEX_COUNTRY_COUNT = 40
PAGE_COUNT = 2

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
    let!(:country) { create_list(:country, INDEX_COUNTRY_COUNT) }
  
    it 'returns summary data for countries' do
      get :index, format: :json
      expect(response).to be_successful
      
      response_body = JSON.parse(response.body)
      expect(response_body['metadata']).to eq({
        'page' => 1,
        'per_page' => DEFAULT_PER_PAGE,
        'page_count' => PAGE_COUNT,
        'total_count' => INDEX_COUNTRY_COUNT
      })
      country_isos_first_page = GeoEntity.order(name: :asc)
        .limit(DEFAULT_PER_PAGE)
        .pluck(:iso3)

      expect(response_body['records'].pluck('iso3')).to match(country_isos_first_page)
    end

    it 'paginates summary data for countries' do
      get :index, format: :json, params: { page: 2 }
      expect(response).to be_successful

      response_body = JSON.parse(response.body)
      first_second_page_country = GeoEntity.order(name: :asc)
        .all[DEFAULT_PER_PAGE]


        expect(response_body['records'].length).to match(INDEX_COUNTRY_COUNT - DEFAULT_PER_PAGE)
        expect(response_body['records'][0]['name']).to match(first_second_page_country.name)
    end
  end
end
