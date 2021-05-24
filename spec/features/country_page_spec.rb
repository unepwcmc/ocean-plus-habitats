require 'rails_helper'

RSpec.feature "Country pages", type: :feature do
  scenario 'Access a country page' do 
    click_button "nav-trigger-nav-primary"
  end
end
