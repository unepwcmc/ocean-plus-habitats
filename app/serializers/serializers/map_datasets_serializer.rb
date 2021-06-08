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
    color: '#0F5F49'
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

WDPA_DATASETS = [
  {
    id: 'wdpa',
    sourceLayers: [
      {
        type: 'point',
        name: 'WDPA_point_Jun2021',
      },
      {
        type: 'poly',
        name: 'WDPA_poly_Jun2021',
      }
    ],
    tilesUrl: 'https://data-gis.unep-wcmc.org/server/rest/services/Hosted/OceanPlus_WDPA_update_2/VectorTileServer/tile/{z}/{y}/{x}.pbf',
    color: '#38A801',
    opacity: 0.5,
    addUnderneath: true,
    name: I18n.t('global.map.wdpa_title'),
    disabled: false,
    image: 'map/stripes-wdpa.png'
  },
  {
    id: 'oecm',
    sourceLayers: [
      {
        type: 'point',
        name: 'WDOECM_point_Jun2021',
      },
      {
        type: 'poly',
        name: 'WDOECM_poly_Jun2021',
      }
    ],
    tilesUrl: 'https://data-gis.unep-wcmc.org/server/rest/services/Hosted/oecm_oceanplus/VectorTileServer/tile/{z}/{y}/{x}.pbf',
    color: '#2700FC',
    opacity: 0.5,
    addUnderneath: true,
    name: I18n.t('global.map.oecm_title'),
    disabled: false,
    image: 'map/stripes-oecm.png'
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
  include CountriesHelper
  include ActionView::Helpers::NumberHelper

  def initialize(habitat_protection_stats, habitat_presence_statuses=HABITATS_PRESENCE_STATUSES_DEFAULT)
    super(habitat_presence_statuses, 'habitat_presence_statuses')
    super(habitat_protection_stats, 'habitat_protection_stats')
  end

  def serialize()
    habitat_datasets = DATASETS.map do |ds|
      dataset = ds.dup
      dataset[:name] = get_habitat_from_id(ds[:id])[:title]
      dataset[:disabled] = absent_or_unknown(habitat_presence_status(ds))
      dataset[:name] += " - #{I18n.t('global.map.no_data').downcase}" if dataset[:disabled]

      dataset
    end
    habitat_datasets + wdpa_datasets
  end

  private

  def wdpa_datasets
    WDPA_DATASETS.map do |ds|
      dataset = ds.dup
      dataset[:image] = ActionController::Base.helpers.image_url(dataset[:image])

      dataset
    end
  end

  def habitat_presence_status dataset
    @habitat_presence_statuses[dataset[:id]]
  end
end
