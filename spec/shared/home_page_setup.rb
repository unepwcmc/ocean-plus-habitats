shared_context 'home_page_setup' do  
  include_context 'geo_entity_stat_setup'

  before do
    allow(GeoEntity).to receive(:permitted_countries).and_return(GeoEntity.all)

    habitats.each do |habitat|
      FactoryBot.create(:global_change_stat, habitat: habitat)

      countries.each do |country|
        FactoryBot.create(:geo_entity_stat, habitat: habitat, geo_entity: country)
      end
    end
  end
end
