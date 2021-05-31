shared_context 'geo_entity_stat_setup' do
  include_context 'countries_setup'

  let(:habitats) { [coralreefs, coldcorals, mangroves, saltmarshes, seagrasses] }

  let(:countries) { FactoryBot.create_list(:country, 3) }
end