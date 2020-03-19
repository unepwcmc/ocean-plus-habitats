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

    @example_species_select = habitats.map { |habitat| { id: habitat[:id], name: habitat[:title] }}
    @example_species_selected = @example_species_select[2].to_json

    @example_species_common = Serializers::SpeciesImagesSerializer.new(@country.all_species).to_json
    @example_species_threatened = Serializers::SpeciesImagesSerializer.new(@country.all_species, true).to_json

    @habitat_change = Serializers::HabitatCountryChangeSerializer.new(@country, habitats_present_status).serialize.to_json

    @stacked_row_chart = {
      legend: [
        {
          id: "multiple",
          title: "Multiple habitats"
        },
        {
          id: "coralreefs",
          title: "Warm-water coral reefs"
        },
        {
          id: "saltmarshes",
          title: "Saltmarshes"
        },
        {
          id: "mangroves",
          title: "Mangroves"
        },
        {
          id: "seagrasses",
          title: "Seagrasses"
        },
        {
          id: "notcovered",
          title: "Not covered"
        }
      ],
      chart: {
        chart_title: "% of length of coastline: xxx,xxx km",
        theme: "habitats",
        rows: [
          {
            percent: '21'.to_f.round,
            label: "1."
          },
          {
            percent: '22'.to_f.round,
            label: "2."
          },
          {
            percent: '15'.to_f.round,
            label: "3."
          },
          {
            percent: '13'.to_f.round,
            label: "4."
          },
          {
            percent: 27,
            label: "5."
          },
          {
            percent: 2,
            label: "6."
          }
        ]
      }
    }
  end
end
