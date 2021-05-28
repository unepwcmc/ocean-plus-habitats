shared_context 'home_page_setup' do  
  let(:configure_app) do 
    FactoryBot.create(:coralreefs) 
    FactoryBot.create(:coldcorals) 
    FactoryBot.create(:saltmarshes) 
    FactoryBot.create(:seagrasses) 
    FactoryBot.create(:mangroves) 
  end
end
