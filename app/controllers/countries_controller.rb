class CountriesController < ApplicationController
  include ApplicationHelper

  def show
    @country = GeoEntity.find_by(name: country_name_from_param(params[:name]))

    return redirect_to(action: 'not_found', controller: 'errors') unless @country

    # TODO: - work out how to integrate i18n with this for country names - we may want to
    # have a list of country names in each language which is then dynamically fetched from
    # a CSV/yml depending on the language selected
    @iso3 = @country&.iso3
    @name = @country.actual_name

    habitats_protection_stats = @country.protection_stats
    habitats_present_status = @country.occurrences

    @map_datasets = Serializers::MapDatasetsSerializer.new(habitats_protection_stats, habitats_present_status).serialize
    @map_datasets_habitats = @map_datasets.reject { |d| %w[wdpa oecm].include?(d[:id]) }
    @habitats_present = Serializers::HabitatsPresentSerializer.new(habitats_present_status, @country).serialize

    red_list_data = @country.count_species
    @red_list_data = habitats.each { |habitat| habitat['data'] = red_list_data[habitat[:id]] }
    @species_count_by_id = Serializers::HabitatSpeciesCountSerializer.new(@red_list_data).to_json

    @example_species_common = Serializers::SpeciesImagesSerializer.new(@country.all_species).to_json
    @example_species_threatened = Serializers::SpeciesImagesSerializer.new(@country.all_species, true).to_json

    @example_species_select = habitats
      .reject { |habitat| habitat['data'].nil? }
      .sort { |h1, h2| h2['data'].last[1] <=> h1['data'].last[1] }
      .map { |habitat| { id: habitat[:id], name: habitat[:title] } }

    @habitat_change = Serializers::HabitatCountryChangeSerializer.new(@country, habitats_present_status).serialize

    @stacked_row_chart = Serializers::RepresentationHabitatsSerializer.new(@country).serialize
    @country_citations = map_to_citations_string(@country.country_citations.order(:citation).pluck(:citation))

    @next_country = next_country
    @next_country_url = country_link_path(@next_country.actual_name)
    @next_country_name = @next_country.actual_name
    @next_country_flag = helpers.if_country_get_flag(@next_country.iso3)

    @red_list_last_updated = Date.parse('2021-08-01').strftime('%b, %Y') # TODO: automate based on date imported
  end

  private

  def next_country
    following_countries = GeoEntity.permitted_countries.select { |geo_entity| geo_entity.name > @country.name }

    return GeoEntity.permitted_countries.first if following_countries.blank?

    following_countries.min_by(&:name)
  end
end
