shared_context 'countries_setup' do
  include_context 'habitats_setup'

  let(:geo_stat) { FactoryBot.create(:geo_entity_stat, habitat: coralreefs) }
  let(:country) { FactoryBot.create(:country, coastal_stat: create(:coastal_stat), geo_entity_stats: [geo_stat]) }
  let(:many_species) { FactoryBot.create_list(:species, 20, habitat: coralreefs, geo_entities: [country]) }
end