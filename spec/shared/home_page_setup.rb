shared_context 'home_page_setup' do  
  let(:configure_app) do 
    # FactoryBot.create(:habitat) 
    FactoryBot.create(:geo_entity_stat)
  end
end
