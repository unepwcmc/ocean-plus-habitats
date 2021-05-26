require 'rails_helper'

RSpec.describe "Country pages", type: :system do
  before do
    driven_by(:rack_test)
  end

  include_context 'home_page_setup'

  scenario 'Access a country page' do 
    configure_app

    visit '/'

    find("#v-select__search").click
  end
end