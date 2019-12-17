class CountriesController < ApplicationController
  include ApplicationHelper
  DATASETS = [
    {
      id: 'coralreefs',
      sourceLayer: 'Ch2_Fg5_mcat5',
      tilesUrl: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/Ch2_Fg5_Oct19/VectorTileServer/tile/{z}/{y}/{x}.pbf',
      color: '#F35F8D',
      descriptionHtml: '<p><strong>00</strong>Warm water coral</p><p><strong>00%</strong>Percentage of warm water coral that occur within a marine protected area</p>'
    },
    {
      id: 'saltmarshes',
      sourceLayer: 'Ch2_Fg5_mcat5',
      tilesUrl: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/Ch2_Fg5_Oct19/VectorTileServer/tile/{z}/{y}/{x}.pbf',
      color: '#332288',
      descriptionHtml: '<p><strong>00</strong>Saltmarsh</p><p><strong>00%</strong>Percentage of saltmarsh that occur within a marine protected area</p>'
    },
    {
      id: 'mangroves',
      sourceLayer: 'Ch2_Fg5_mcat5',
      tilesUrl: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/Ch2_Fg5_Oct19/VectorTileServer/tile/{z}/{y}/{x}.pbf',
      color: '#D6A520',
      descriptionHtml: '<p><strong>00</strong>Mangroves</p><p><strong>00%</strong>Percentage of mangroves that occur within a marine protected area</p>'
    }
  ].freeze

  def index
  end

  def show
    @country = GeoEntity.find_by(name: country_name_from_param(params[:name]))
    @yml_key = @country[:name].downcase.gsub(/ /, '_').gsub('%27', "")

    country_yml = I18n.t("countries.#{@yml_key}")

    #TODO: Ferdi to generate this from CSVs.
    habitats_present_status = {
      coralreefs: 'unknown',
      saltmarshes: 'absent',
      mangroves: 'present',
      seagrasses: 'present',
      coldcorals: 'present'
    }

    @map_datasets = Serializers::MapDatasetsSerializer.new(habitats_present_status, DATASETS).serialize
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
