require 'rails_helper'

RSpec.fdescribe "Home page", type: :system, driver: :selenium_chrome, js: true do
  include_context 'home_page_setup'

  before { visit '/' }

  scenario 'Accessing the country dropdown' do 
    dropdown = find_all('#v-select-search-country').first
    
    dropdown.click

    expect(page).to have_css('#v-select-dropdown-country > li.v-select__option', count: 4)
    expect(page).to have_all_of_selectors(
      "#option-country-#{GeoEntity.first.id}", 
      "#option-country-#{GeoEntity.second.id}",
      "#option-country-#{GeoEntity.third.id}",
      "#option-country-#{GeoEntity.fourth.id}"
    )
  end

  scenario 'Downloading set of global statistics as a zip' do 
    download_link = find('a', text: 'Download statistics')

    expect(download_link[:href]).to eq("#{page.current_url}downloads/global_statistics.zip")
  end

  # Not actually going to try to download the shapefiles, they are massive!
  scenario 'Opening the spatial data downloads modal' do
    expect(page).to_not have_css('.modal__dialog')

    find('#modal-trigger-spatial-downloads').click

    expect(page).to have_css('.modal__dialog')
    
    downloads_dialog = find('.modal__dialog')

    expect(downloads_dialog).to have_content('Select habitat shape file')
    
    expect(downloads_dialog).to have_css('.radio-group.download-radio-buttons__radio-group > li.radio-group__item', count: 5)

    downloads_dialog.find('label[for*="saltmarshes"] > .radio-button__radio').click

    download_button = find('.button--radio-group-download')
    
    expect(download_button[:href]).to eq(DownloadsHelper::DOWNLOAD_LINKS[:saltmarshes])
  end

  scenario 'Viewing the sources modals' do
    find_all('#modal-trigger-citation').first.click

    expect(page).to have_css('.modal__content')

    modal = find('.modal__content')

    expect(modal).to have_text('Sources')
  end

  scenario 'Selecting layers within the EEZ map' do
    expect(page).to have_css('#eez_map')

    eez_map = find('#eez_map')

    expect(eez_map).to have_css('.map-filters__filter.map-filters__filter--eez')

    eez_map.find('.map-filters__filter-key.map-filters__filter-key--eez-coldcorals').click

    expect(eez_map).to have_css(
      '.map-filters__filter.active.map-filters__filter--eez > label > .map-filters__filter-key.map-filters__filter-key--eez-coldcorals'
    )
  end
end