class CountriesController < ApplicationController
  include ApplicationHelper

  def show
    @country = GeoEntity.find_by(name: country_name_from_param(params[:name]))

    # TODO - work out how to integrate i18n with this for country names - we may want to
    # have a list of country names in each language which is then dynamically fetched from
    # a CSV/yml depending on the language selected
    @name = @country.name.downcase.gsub(/ /, ' ').gsub('%27', "").split(' ').map(&:capitalize).join(' ')

    habitats_protection_stats = @country.protection_stats
    habitats_present_status = @country.occurrences

    @map_datasets = Serializers::MapDatasetsSerializer.new(habitats_protection_stats, habitats_present_status).serialize
    @habitats_present = Serializers::HabitatsPresentSerializer.new(habitats_present_status, @country).serialize

    red_list_data = @country.count_species
    @red_list_data = habitats.each { |habitat| habitat['data'] = red_list_data[habitat[:id]] }
    @species_count_by_id = Serializers::HabitatSpeciesCountSerializer.new(@red_list_data).to_json

    @example_species_common = Serializers::SpeciesImagesSerializer.new(@country.all_species).to_json
    @example_species_threatened = Serializers::SpeciesImagesSerializer.new(@country.all_species, true).to_json

    @example_species_select = habitats.reject { |habitat| habitat['data'].nil? }.sort { |h1, h2| h2['data'].last[1] <=> h1['data'].last[1] }.
    map { |habitat| { id: habitat[:id], name: habitat[:title] }}

    @habitat_change = Serializers::HabitatCountryChangeSerializer.new(@country, habitats_present_status).serialize

    @stacked_row_chart = Serializers::RepresentationHabitatsSerializer.new(@country).serialize
    @country_citations = @country.country_citations.order(:citation).pluck(:citation)
  end
end
