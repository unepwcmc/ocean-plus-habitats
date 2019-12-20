DATASETS = [
  {
    id: 'coralreefs',
    sourceLayers: {
      point: 'WCMC008_CoralReef2018_Pt_v4',
      poly: 'WCMC008_CoralReef2018_Py_v4',
      line: 'WCMC008_CoralReef2018_Py_v4'
    },
    tilesUrl: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/Global_Distribution_of_Coral_Reefs/VectorTileServer/tile/{z}/{y}/{x}.pbf',
    color: '#F35F8D'
  },
  {
    id: 'saltmarshes',
    sourceLayers: {
      point: 'WCMC027_Saltmarshes_Pt_v6',
      poly: 'WCMC027_Saltmarshes_Py_v6',
      line: 'WCMC027_Saltmarshes_Py_v6',
    },
    tilesUrl: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/Global_Distribution_of_Saltmarshes/VectorTileServer/tile/{z}/{y}/{x}.pbf',
    color: '#332288'
  },
  {
    id: 'mangroves',
    sourceLayers: {
      poly: 'GMW_2016_v2',
      line: 'GMW_2016_v2',
    },
    tilesUrl: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/Global_Mangrove_Watch_2016/VectorTileServer/tile/{z}/{y}/{x}.pbf',
    color: '#D6A520'
  },
  {
    id: 'seagrasses',
    sourceLayers: {
      point: 'WCMC_013_014_SeagrassesPt_v6',
      poly: 'WCMC_013_014_SeagrassesPy_v6',
      line: 'WCMC_013_014_SeagrassesPy_v6'
    },
    tilesUrl: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/Global_Distribution_of_Seagrasses/VectorTileServer/tile/{z}/{y}/{x}.pbf',
    color: '#88CCEE',
  },
  {
    id: 'coldcorals',
    sourceLayers: {
      point: 'WCMC001_ColdCorals2017_Pt_v5',
      poly: 'WCMC001_ColdCorals2017_Py_v5',
      line: 'WCMC001_ColdCorals2017_Py_v5'
    },
    tilesUrl: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/Global_Distribution_of_Cold_water_Corals/VectorTileServer/tile/{z}/{y}/{x}.pbf',
    color: '#E61354'
  }
].freeze

HABITATS_PRESENCE_STATUSES_DEFAULT = {
  coralreefs: 'present',
  saltmarshes: 'present',
  mangroves: 'present',
  seagrasses: 'present',
  coldcorals: 'present'
}.freeze

class Serializers::MapDatasetsSerializer < Serializers::Base
  include ApplicationHelper

  def initialize(habitat_protection_stats, habitat_presence_statuses=HABITATS_PRESENCE_STATUSES_DEFAULT)
    super(habitat_presence_statuses, 'habitat_presence_statuses')
    super(habitat_protection_stats, 'habitat_protection_stats')
  end

  def serialize
    map_datasets = DATASETS.reject {|ds| habitat_presence_status(ds) == 'absent'}

    map_datasets.map do |ds|
      dataset = ds.dup
      dataset[:name] = get_habitat_from_id(ds[:id])[:title]
      dataset[:disabled] = habitat_presence_status(ds) == 'unknown' ? true : false
      set_dataset_description_html(dataset)

      dataset
    end
  end

  private

  def set_dataset_description_html dataset
    if habitat_presence_status(dataset) == 'unknown'
      dataset[:descriptionHtml] = not_available_dataset_html
    else
      total_units = dataset[:id] == 'coldcorals' ? 'observations' : 'km<sup>2</sup>'
      habitat_stats = @habitat_protection_stats[dataset[:id]]
      protected_percentage = habitat_stats['protected_percentage'].round(2)
      total_value = habitat_stats['total_value']
      total_value = total_units == 'observations' ? total_value.to_int : total_value.round(2)

      dataset[:descriptionHtml] = I18n.t(
        'countries.shared.locations_map.filter_description_html', 
        {
          habitat: dataset[:name],
          habitat_downcase: dataset[:name].downcase,
          total: "#{total_value} #{total_units}",
          percentage: protected_percentage,
        }
      )
    end
  end

  def habitat_presence_status dataset
    @habitat_presence_statuses[dataset[:id]]
  end

  def not_available_dataset_html
    "<p>#{I18n.t('shared.map_not_available')}</p>"
  end
end
