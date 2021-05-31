require 'rails_helper'

RSpec.describe "Site", type: :request do
  describe 'GET #index' do
    include_context 'countries_setup'

    before do
      habitats = [coralreefs, coldcorals, mangroves, saltmarshes, seagrasses]

      habitats.each do |habitat|
        FactoryBot.create(:global_change_stat, habitat: habitat)
      end
      
      countries = FactoryBot.create_list(:country, 3)

      habitats.each do |habitat|
        countries.each do |country|
          FactoryBot.create_list(:geo_entity_stat, rand(5), habitat: habitat, geo_entity: country)
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
