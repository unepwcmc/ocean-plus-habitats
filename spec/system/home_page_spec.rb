require 'rails_helper'

RSpec.describe "Home page", type: :system, driver: :selenium_chrome, js: true do
  include_context 'home_page_setup'

  scenario 'Accessing the country dropdown' do 
    visit '/'

    find_all('#v-select-search-country').first.click

    expect(page).to have_all_of_selectors(
      "#option-country-#{GeoEntity.first.id}", 
      "#option-country-#{GeoEntity.second.id}",
      "#option-country-#{GeoEntity.third.id}"
    )
  end

  scenario 'Downloading set of global statistics as a zip' do 
    visit '/'

    download_link = find('a', text: 'Download statistics')

    expect(download_link[:href]).to eq("#{page.current_url}downloads/global_statistics.zip")
  end

  # Not actually going to try to download the shapefiles, they are massive!
  scenario 'Opening the spatial data downloads modal' do
    visit '/'

    find('#modal-trigger-spatial-downloads').click

    expect(page).to have_css('.modal__dialog')

    # Can be flaky because of the dependence on the very specific `for` attribute
    page.find('label[for="download-radio-buttons-56-option-saltmarshes"] > .radio-button__radio').click

    download_button = find('.button--radio-group-download')
    
    expect(download_button[:href]).to eq(DownloadsHelper::DOWNLOAD_LINKS[:saltmarshes])
  end

  scenario 'Viewing the sources modals' do
    visit '/'

    find_all('#modal-trigger-citation').first.click

    expect(page).to have_css('.modal__content')
    expect(page).to have_text('Sources')
  end

  scenario 'Selecting layers within the EEZ map' do
    visit '/'

    expect(page).to have_css('#eez_map')

    expect(page).to have_css('.map-filters__filter.map-filters__filter--eez')

    page.find('.map-filters__filter-key.map-filters__filter-key--eez-coldcorals').click

    expect(page).to have_css(
      '.map-filters__filter.active.map-filters__filter--eez > label > .map-filters__filter-key.map-filters__filter-key--eez-coldcorals'
    )
  end
end