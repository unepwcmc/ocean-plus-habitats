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

class Serializers::MapDatasetsSerializer < Serializers::Base
  include ApplicationHelper

  def initialize(habitat_presence_statuses)
    super(habitat_presence_statuses, 'habitat_presence_statuses')
  end

  def serialize
    map_datasets = DATASETS.reject {|ds| habitat_presence_status(ds) == 'absent'}

    map_datasets.map do |ds| 
      dataset = ds.dup
      dataset[:name] = get_habitat_from_id(ds[:id])[:title]

      if habitat_presence_status(ds) == 'unknown' 
        dataset[:disabled] = true
        dataset[:descriptionHtml] = not_available_dataset_html
      end

      dataset
    end
  end

  private

  def habitat_presence_status dataset
    @habitat_presence_statuses[dataset[:id].to_sym]
  end

  def not_available_dataset_html
    "<p>#{I18n.t('shared.map_not_available')}</p>"
  end
end
