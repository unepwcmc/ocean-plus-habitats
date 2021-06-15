require 'rails_helper'

RSpec.describe "Site", type: :request do
  describe 'GET #index' do
    include_context 'home_page_setup'

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

  describe 'GET #legal' do
    it 'loads the legal page' do
      get '/site/legal'

      expect(response).to be_successful
      expect(response.content_type).to eq('text/html')
    end
  end  
end
