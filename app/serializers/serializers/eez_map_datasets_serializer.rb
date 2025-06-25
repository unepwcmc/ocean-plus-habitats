EEZ_COLORS = {
  'no-data' => '#939393',
  '0-20' => '#E3E3E3',
  '21-40' => '#B3CDE3',
  '41-60' => '#8C96C6',
  '61-80' => '#8856A7',
  '81-100' => '#810F7C'
}.freeze

class Serializers::EezMapDatasetsSerializer < Serializers::Base
  def initialize
  end

  def serialize
    Habitat.pluck(:name).uniq.map do |habitat|
      eez_dataset_hash(habitat)
    end
  end

  private

  SERVICES = {
    'coralreefs' => 'Coral_Reef_Projection',
    'saltmarshes' => 'Saltmarsh_Projection',
    'mangroves' => 'Mangrove_Protection',
    'seagrasses' => 'Seagrass_Projection',
    'coldcorals' => 'Cold_Coral_Projection'
  }.freeze
  def eez_dataset_hash(habitat)
    {
      id: "eez-#{habitat}",
      name: habitat.camelize,
      title: Habitat.where(name: habitat).pluck(:title)[0],
      sourceLayers: source_layers(habitat),
      tilesUrl: "https://data-gis.unep-wcmc.org/server/rest/services/Hosted/#{SERVICES[habitat]}/VectorTileServer/tile/{z}/{y}/{x}.pbf",
      opacity: 0.7
    }
  end

  LAYERS = %w(no-data 0-20 21-40 41-60 61-80 81-100).freeze
  NAMES = {
    'coralreefs' => 'ProtectionCoralReef',
    'saltmarshes' => 'ProtectionSaltmarsh',
    'mangroves' => 'ProtectionMangroves',
    'seagrasses' => 'ProtectionSeagrasses',
    'coldcorals' => 'ProtectionColdCoral'
  }.freeze
  def source_layers(habitat)
    LAYERS.map.with_index do |l, idx|
      {
        type: 'poly',
        name: NAMES[habitat],
        sub_name: l,
        filter_id: idx + 1,
        color: EEZ_COLORS[l]
      }
    end
  end
end
