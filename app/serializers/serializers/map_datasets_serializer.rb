DATASETS = [
  {
    id: 'coralreefs',
    sourceLayers: [
      {
        type: 'point',
        name: 'WCMC008_CoralReef2018_Pt_v4',
      },
      {
        type: 'poly',
        name: 'WCMC008_CoralReef2018_Py_v4',
      },
      {
        type: 'line',
        name: 'WCMC008_CoralReef2018_Py_v4'
      }
    ],
    tilesUrl: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/Global_Distribution_of_Coral_Reefs/VectorTileServer/tile/{z}/{y}/{x}.pbf',
    color: '#F35F8D'
  },
  {
    id: 'saltmarshes',
    sourceLayers: [
      {
        type: 'point',
        name: 'WCMC027_Saltmarshes_Pt_v6',
      },
      {
        type: 'poly',
        name: 'WCMC027_Saltmarshes_Py_v6',
      },
      {
        type: 'line',
        name: 'WCMC027_Saltmarshes_Py_v6'
      }
    ],
    tilesUrl: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/Global_Distribution_of_Saltmarshes/VectorTileServer/tile/{z}/{y}/{x}.pbf',
    color: '#332288'
  },
  {
    id: 'mangroves',
    sourceLayers: [
      {
        type: 'poly',
        name: 'GMW_2016_v2',
      },
      {
        type: 'line',
        name: 'GMW_2016_v2',
      }
    ],
    tilesUrl: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/Global_Mangrove_Watch_2016/VectorTileServer/tile/{z}/{y}/{x}.pbf',
    color: '#D6A520'
  },
  {
    id: 'seagrasses',
    sourceLayers: [
      {
        type: 'point',
        name: 'WCMC_013_014_SeagrassesPt_v6'
      },
      {
        type: 'poly',
        name: 'WCMC_013_014_SeagrassesPy_v6'
      },
      {
        type: 'line',
        name: 'WCMC_013_014_SeagrassesPy_v6'
      }
    ],
    tilesUrl: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/Global_Distribution_of_Seagrasses/VectorTileServer/tile/{z}/{y}/{x}.pbf',
    color: '#88CCEE',
  },
  {
    id: 'coldcorals',
    sourceLayers: [
      {
        type: 'point',
        name: 'WCMC001_ColdCorals2017_Pt_v5',
      },
      {
        type: 'poly',
        name: 'WCMC001_ColdCorals2017_Py_v5',
      },
      {
        type: 'line',
        name: 'WCMC001_ColdCorals2017_Py_v5'
      }
    ],
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
  include ActionView::Helpers::NumberHelper

  def initialize(habitat_protection_stats, habitat_presence_statuses=HABITATS_PRESENCE_STATUSES_DEFAULT)
    super(habitat_presence_statuses, 'habitat_presence_statuses')
    super(habitat_protection_stats, 'habitat_protection_stats')
  end

  def serialize
    DATASETS.map do |ds|
      dataset = ds.dup
      dataset[:name] = get_habitat_from_id(ds[:id])[:title]
      dataset[:disabled] = habitat_presence_status(ds) == 'unknown' || habitat_presence_status(ds) == 'absent'  ? true : false

      dataset
    end
  end

  private


  def habitat_presence_status dataset
    @habitat_presence_statuses[dataset[:id]]
  end

  def not_available_dataset_html
    "<p>#{I18n.t('global.map_not_available')}</p>"
  end
end
