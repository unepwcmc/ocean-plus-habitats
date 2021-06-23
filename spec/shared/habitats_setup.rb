shared_context 'habitats_setup' do
  let(:coralreefs) { FactoryBot.create(:coralreefs) }
  let(:coldcorals) { FactoryBot.create(:coldcorals) }
  let(:saltmarshes) { FactoryBot.create(:saltmarshes) } 
  let(:seagrasses) { FactoryBot.create(:seagrasses) }
  let(:mangroves) { FactoryBot.create(:mangroves) } 
end