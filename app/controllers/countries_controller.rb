class CountriesController < ApplicationController
  include ApplicationHelper

  def index
  end

  def show
    @country = GeoEntity.find_by(name: country_name_from_param(params[:name]))
    @yml_key = @country[:name].downcase.gsub(/ /, '_').gsub('%27', "")

    country_yml = I18n.t("countries.#{@yml_key}")

    @habitats_present_status = {
      coralreefs: 'unknown',
      saltmarshes: 'absent',
      mangroves: 'present',
      seagrasses: 'present',
      coldcorals: 'present'
    }

    layers = [
      {
        id: 'coralreefs',
        name: 'Warm water coral',
        sourceLayer: 'Ch2_Fg5_mcat5',
        tilesUrl: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/Ch2_Fg5_Oct19/VectorTileServer/tile/{z}/{y}/{x}.pbf',
        color: '#F35F8D',
        descriptionHtml: '<p><strong>00</strong>Warm water coral</p><p><strong>00%</strong>Percentage of warm water coral that occur within a marine protected area</p>'
      },
      {
        id: 'saltmarshes',
        name: 'Saltmarshes',
        sourceLayer: 'Ch2_Fg5_mcat5',
        tilesUrl: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/Ch2_Fg5_Oct19/VectorTileServer/tile/{z}/{y}/{x}.pbf',
        color: '#332288',
        descriptionHtml: '<p><strong>00</strong>Saltmarsh</p><p><strong>00%</strong>Percentage of saltmarsh that occur within a marine protected area</p>'
      },
      {
        id: 'mangroves',
        name: 'Mangroves',
        sourceLayer: 'Ch2_Fg5_mcat5',
        tilesUrl: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/Ch2_Fg5_Oct19/VectorTileServer/tile/{z}/{y}/{x}.pbf',
        color: '#D6A520',
        descriptionHtml: '<p><strong>00</strong>Mangroves</p><p><strong>00%</strong>Percentage of mangroves that occur within a marine protected area</p>'
      }
    ]

    @dummy_layers = layers
      .reject {|l| self.habitat_present_status(l) == 'absent'}
      .map {|l| self.habitat_present_status(l) == 'unknown' ? l.merge({disabled: true}) : l}

    @habitats_present = Serializers::HabitatsPresentSerializer.new(@habitats_present_status, country_yml).serialize

    red_list_data = @country.count_species
    @red_list_data = habitats.each { |habitat| habitat['data'] = red_list_data[habitat[:id]] }

    @example_species_select = habitats.map { |habitat| { id: habitat[:id], name: habitat[:title] }}
    @example_species_selected = @example_species_select[2].to_json

    @example_species_common = Serializers::SpeciesImagesSerializer.new(@country.species).to_json
    @example_species_threatened = Serializers::SpeciesImagesSerializer.new(@country.species, true).to_json

    @habitat_change = Serializers::HabitatCountryChangeSerializer.new(@country).serialize.to_json

    @target_text = country_yml[:targets]
  end

  def habitat_present_status layer
    # byebug
    @habitats_present_status[layer[:id].to_sym]
  end
end
