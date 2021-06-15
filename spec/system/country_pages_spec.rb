require 'rails_helper'

# TODO - need to set up Selenium properly so it can actually interact with JS
RSpec.xdescribe "Country pages", type: :system do
  before do
    driven_by(:rack_test)
  end

  include_context 'home_page_setup'

  scenario 'Access a country page' do 
    visit '/'

    expect(page).to have_css('.header__content', text: 'Country')
  end
end