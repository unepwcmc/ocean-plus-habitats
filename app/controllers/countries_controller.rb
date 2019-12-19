class CountriesController < ApplicationController
  include ApplicationHelper

  def show
    @country = GeoEntity.find_by(name: country_name_from_param(params[:name]))
    @yml_key = @country.name.downcase.gsub(/ /, '_').gsub('%27', "")

    country_yml = I18n.t("countries.#{@yml_key}")

    habitats_protection_stats = @country.protection_stats
    habitats_present_status = @country.occurrences

    @map_datasets = Serializers::MapDatasetsSerializer.new(habitats_present_status, habitats_protection_stats).serialize
    @habitats_present = Serializers::HabitatsPresentSerializer.new(habitats_present_status, country_yml).serialize

    red_list_data = @country.count_species
    @red_list_data = habitats.each { |habitat| habitat['data'] = red_list_data[habitat[:id]] }

    @example_species_select = habitats.map { |habitat| { id: habitat[:id], name: habitat[:title] }}
    @example_species_selected = @example_species_select[2].to_json

    @example_species_common = Serializers::SpeciesImagesSerializer.new(@country.species).to_json
    @example_species_threatened = Serializers::SpeciesImagesSerializer.new(@country.species, true).to_json

    @habitat_change = Serializers::HabitatCountryChangeSerializer.new(@country).serialize.to_json

    @target_text = country_yml[:targets]
  end
end
