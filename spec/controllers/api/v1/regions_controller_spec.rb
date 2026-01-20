require 'rails_helper'

RSpec.describe Api::V1::RegionsController, type: :controller do
  describe 'GET #show' do
    let!(:region) { create_list(:region, 2, is_region: true) }

    it 'returns summary data for a region' do
      get :show, params: { id: region.first.id }, format: :json
      expect(response).to be_successful

      response_body = JSON.parse(response.body)
      expect(response_body['name']).to match(region.first.name)
    end

    it 'returns child countries and correct statistics keys' do
      get :show, params: { id: region.first.id }, format: :json
      expect(response).to be_successful

      response_body = JSON.parse(response.body)
      expect(response_body).to include(
        'id',
        'name',
        'countries',
        'habitat_change_statistics',
        'species_status',
        'protected_area_statistics'
      )
      expect(response_body['countries'].count).to eq(2)
    end
  end

  describe 'GET #index' do
    let!(:region) { create_list(:region, 2, is_region: true) }
  
    it 'returns list of regions' do
      get :index, format: :json
      expect(response).to be_successful
      
      response_body = JSON.parse(response.body)
      expect(response_body.map{ |r| r['name'] }).to match(GeoEntity.regions.pluck(:name))
    end
  end
end
