class CountriesController < ApplicationController
  include ApplicationHelper

  def show
    @country = GeoEntity.find_by(name: country_name_from_param(params[:name]))
    @yml_key = @country.name.downcase.gsub(/ /, '_').gsub('%27', "")

    country_yml = I18n.t("countries.#{@yml_key}")

    habitats_protection_stats = @country.protection_stats
    habitats_present_status = @country.occurrences

    @map_datasets = Serializers::MapDatasetsSerializer.new(habitats_protection_stats, habitats_present_status).serialize
    @habitats_present = Serializers::HabitatsPresentSerializer.new(habitats_present_status, country_yml).serialize

    red_list_data = @country.count_species
    @red_list_data = habitats.each { |habitat| habitat['data'] = red_list_data[habitat[:id]] }
    @species_count_by_id = Serializers::HabitatSpeciesCountSerializer.new(@red_list_data).to_json

    @example_species_common = Serializers::SpeciesImagesSerializer.new(@country.all_species).to_json
    @example_species_threatened = Serializers::SpeciesImagesSerializer.new(@country.all_species, true).to_json

    @example_species_select = habitats.reject { |habitat| habitat['data'].nil? }.sort { |h1, h2| h2['data'].last[1] <=> h1['data'].last[1] }.
    map { |habitat| { id: habitat[:id], name: habitat[:title] }}
    @example_species_selected = @example_species_select.find { |habitat|
     ( habitat[:id] ==  'mangroves' ||  habitat[:id] ==  'seagrasses' ) || ( habitat[:id] == 'saltmarshes' || habitat[:id] == 'coralreefs' || habitat[:id] == 'coldcorals')
    }.to_json

    @habitat_change = Serializers::HabitatCountryChangeSerializer.new(@country, habitats_present_status).serialize

    @stacked_row_chart = Serializers::RepresentationHabitatsSerializer.new(@country).serialize
  end
end
