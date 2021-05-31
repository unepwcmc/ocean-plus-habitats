require 'rails_helper'

RSpec.describe Habitat, type: :model do
  include_context 'habitats_setup'

  let(:habitat) { coralreefs }

  describe '#global_coverage_title' do
    let(:habitat_type) { 'points' }

    subject(:action) { habitat.global_coverage_title(habitat_type) }

    it 'outputs the correct string' do
      expect(action).to eq("Total number of #{habitat.title.downcase} records globally")
    end
  end

  describe '#protected_title' do
    it 'returns the correct output' do
      expect(habitat.protected_title).to eq("Percentage of #{habitat.title.downcase} that occur within a marine protected area")
    end
  end

  context 'calculating statistics' do
    let(:habitat) { mangroves }
    let(:country) { FactoryBot.create(:country_with_mangroves) }
    
    before { FactoryBot.create(:present_stat, habitat: habitat, geo_entity: country) }

    it 'calculates the correct country cover change' do
      expect(habitat.calculate_country_cover_change(country.name)).to eq(
        {
          change_km: '0.4',
          change_percentage: 0.8e2
        }
      )
    end

    it 'calculates the correct global cover change' do
      expect(habitat.calculate_global_cover_change).to eq({ baseline_year: 2010, change_km: 0.4e0, change_percentage: 0.8e2, original_total: 0.5e0 })
    end

    it 'returns the correct statistics' do
      expect(habitat.global_stats).to eq({ protected_habitat_cover: 0.38e2, total_habitat_cover: 0.1e3 })
    end

    it 'calculates the global protection' do
      expect(habitat.calculate_global_protection).to eq({ 'protected_percentage' => 38.0, 'total_value' => 100.0 })
    end

    it 'retrieves the occurrence of the habitat' do   
      expect(habitat.occurrence(country.id)).to eq('present')
    end

    describe '#total_value_by_country' do
      let(:carto) { instance_double(Carto) }
      
      before { allow(Carto).to receive(:new).and_return(carto) }

      context 'when habitat is coldcorals' do
        let(:habitat) { FactoryBot.create(:coldcorals) }

        it 'returns the total number of points' do
          allow(carto).to receive(:total_points_by_country).and_return(
            [{ "iso3": country.iso3, "count": 30 }.with_indifferent_access]
          )
        
          expect(habitat.total_value_by_country).to eq({ "#{country.iso3}" => 30 })
        end
      end

      context 'when habitat is not coldcorals' do        
        it 'returns the total area' do
          allow(carto).to receive(:total_area_by_country).and_return(
            [[{ "iso3": country.iso3, "sum": 30 }.with_indifferent_access]]
          )
       
          expect(habitat.total_value_by_country).to eq({ "#{country.iso3}" => 30 })
        end
      end
    end
  end
end
