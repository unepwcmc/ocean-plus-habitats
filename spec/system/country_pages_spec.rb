require 'rails_helper'

RSpec.fdescribe "Country pages", type: :system do
  before do
    driven_by(:rack_test)
  end

  include_context 'home_page_setup'

  scenario 'Access a country page' do 
    configure_app

    visit '/'

    expect(page).to have_css('.header__content', text: 'Country')
  end
end