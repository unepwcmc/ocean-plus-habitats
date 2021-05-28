require 'rails_helper'

RSpec.fdescribe "Countries", type: :request do
  include_context 'countries_setup'

  let(:headers) { { "Accept": "application/json" } }

  before do
    country
  end

  describe "GET /:country" do
    it 'gets the index page' do
      get '/country'

      expect(response).to be_successful
      expect(response.content_type).to eq("text/html; charset=utf-8")
    end
  end
end
