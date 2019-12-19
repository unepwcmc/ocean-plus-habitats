DATASETS = [
  {
    id: 'coralreefs',
    sourceLayer: 'Ch2_Fg5_mcat5',
    tilesUrl: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/Ch2_Fg5_Oct19/VectorTileServer/tile/{z}/{y}/{x}.pbf',
    color: '#F35F8D'
  },
  {
    id: 'saltmarshes',
    sourceLayer: 'Ch2_Fg5_mcat5',
    tilesUrl: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/Ch2_Fg5_Oct19/VectorTileServer/tile/{z}/{y}/{x}.pbf',
    color: '#332288'
  },
  {
    id: 'mangroves',
    sourceLayer: 'Ch2_Fg5_mcat5',
    tilesUrl: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/Ch2_Fg5_Oct19/VectorTileServer/tile/{z}/{y}/{x}.pbf',
    color: '#D6A520'
  },
  {
    id: 'seagrasses',
    sourceLayer: 'Ch2_Fg5_mcat5',
    tilesUrl: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/Ch2_Fg5_Oct19/VectorTileServer/tile/{z}/{y}/{x}.pbf',
    color: '#88CCEE'
  },
  {
    id: 'coldcorals',
    sourceLayer: 'Ch2_Fg5_mcat5',
    tilesUrl: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/Ch2_Fg5_Oct19/VectorTileServer/tile/{z}/{y}/{x}.pbf',
    color: '#E61354'
  }
].freeze

class Serializers::MapDatasetsSerializer < Serializers::Base
  include ApplicationHelper

  def initialize(habitat_presence_statuses, habitat_protection_stats)
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

      dataset[:descriptionHtml] = I18n.t(
        'countries.shared.locations_map.filter_description_html', 
        {
          habitat: dataset[:name],
          habitat_downcase: dataset[:name].downcase,
          total: "#{habitat_stats['total_value'].round(2)} #{total_units}",
          percentage: habitat_stats['protected_percentage'].round(2),
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
