require 'rails_helper'

RSpec.describe "Site", type: :request do
  describe 'GET #index' do
    include_context 'geo_entity_stat_setup'

    before do
      habitats.each do |habitat|
        FactoryBot.create(:global_change_stat, habitat: habitat)
      end
      
      habitats.each do |habitat|
        countries.each do |country|
          FactoryBot.create(:geo_entity_stat, habitat: habitat, geo_entity: country)
        end
      end
    end

    it 'loads the main page' do
      get '/'

      expect(response).to be_successful
      expect(response.content_type).to eq('text/html')
    end
  end

  describe 'GET #about' do
    it 'loads the about page' do
      get '/site/about'

      expect(response).to be_successful
      expect(response.content_type).to eq('text/html')
    end
  end

  describe 'GET #methodologies' do
    it 'loads the methodologies page' do
      get '/site/methodologies'

      expect(response).to be_successful
      expect(response.content_type).to eq('text/html')
    end
  end  
end
