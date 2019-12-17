class CountriesController < ApplicationController
  include ApplicationHelper

  def index
  end

  def show
    @country = GeoEntity.find_by(name: country_name_from_param(params[:name]))
    @yml_key = @country[:name].downcase.gsub(/ /, '_').gsub('%27', "")

    country_yml = I18n.t("countries.#{@yml_key}")

    habitat_citations = country_yml[:habitats_present_citations]

    habitats_present_data = [
      { status: 'present', status_title: get_status_text('present')},
      { status: 'absent', status_title: get_status_text('absent')},
      { status: 'unknown', status_title: get_status_text('unknown')},
      { status: 'present', status_title: get_status_text('present')},
      { status: 'present', status_title: get_status_text('present')}
    ]

    @habitats_present = habitats.zip(habitats_present_data, habitat_citations)

    @species_count = @country.species_count
    red_list_data = @country.count_species
    @red_list_data = habitats.each { |habitat| habitat['data'] = red_list_data[habitat[:id]] }

    @example_species_select = habitats.map { |habitat| { id: habitat[:id], name: habitat[:title] }}
    @example_species_selected = @example_species_select[2].to_json

    @example_species_common = Serializers::SpeciesImagesSerializer.new(@country.species).to_json
    @example_species_threatened = Serializers::SpeciesImagesSerializer.new(@country.species, true).to_json

    @habitat_change = Serializers::HabitatCountryChangeSerializer.new(@country).serialize.to_json

    @target_text = country_yml[:targets]
  end

  private

  def get_status_text status
    I18n.t("countries.shared.habitats_present.title_#{status}")
  end
end
