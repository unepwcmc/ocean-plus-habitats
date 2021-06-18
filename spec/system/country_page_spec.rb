require 'rails_helper'

RSpec.describe "Country page", type: :system, driver: :selenium_chrome, js: true do
  include_context 'countries_setup'

  let(:country_path) { country_path = GeoEntity.last.name.downcase.gsub(/ /, '-') }

  before do
    allow(GeoEntity).to receive(:permitted_countries).and_return(GeoEntity.all)
    country
    many_species
  
    visit "/#{country_path}"
  end

  scenario 'Visiting a country page' do
    expect(page).to have_content(GeoEntity.last.actual_name)
  end

  scenario 'Finding the total length of the coastline' do
    chart_title = find('.habitat-representation__chart-title')

    unrounded_coastline = GeoEntity.last.coastal_stat.total_coast_length
    coastline_length = delimit(unrounded_coastline.round)

    expect(chart_title.text).to eq("Percentage of coastline (#{coastline_length} km) covered by habitats")
  end

  scenario 'Looking at example of species section' do  
    example_of_species_section = find('.example-species')

    expect(example_of_species_section).to have_content('Total number of species: 20')

    species_common_names = GeoEntity.last.species.take(3).pluck(:common_name)

    expect(example_of_species_section).to have_content(species_common_names[0])
    expect(example_of_species_section).to have_content(species_common_names[1])
    expect(example_of_species_section).to have_content(species_common_names[2])
  end

  scenario 'Opening the main national data sources modal' do
    find('.downloads__li > #modal-trigger-citation').click

    expect(page).to have_css('.modal__dialog')
  end

  scenario 'Downloading set of national statistics as a zip' do 
    download_link = find('a', text: 'Download statistics')

    root_url = page.current_url.delete_suffix(country_path)
    expect(download_link[:href]).to eq("#{root_url}downloads/national/#{GeoEntity.last.iso3}.zip")
  end
end