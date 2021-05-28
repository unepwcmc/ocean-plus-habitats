shared_context 'countries_setup' do
  include_context 'habitats_setup'

  let(:coastal_stat) { FactoryBot.create(:coastal_stat) }
  let(:country) { FactoryBot.create(:geo_entity, coastal_stat: coastal_stat) }
  let(:geo_entity_stat) { FactoryBot.create(:geo_entity_stat, geo_entity: country, habitat: coralreefs) }
end