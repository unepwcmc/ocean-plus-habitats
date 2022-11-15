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
    let(:change_stat) { habitat.change_stats.first }
    let(:change_km) { (change_stat.total_value_2016 - change_stat.total_value_2010).round(2) }
    let(:change_percentage) { ( change_km / change_stat.total_value_2010 ) * 100 }
    let(:global_protected_percentage) do
      habitat.geo_entity_stats.country_stats.pluck(:protected_value).compact.reduce(&:+) 
    end
    let(:global_habitat_cover) do 
      habitat.geo_entity_stats.country_stats.pluck(:total_value).compact.reduce(&:+) 
    end
    
    before { FactoryBot.create(:present_stat, habitat: habitat, geo_entity: country) }

    it 'calculates the correct country cover change' do
      expect(habitat.calculate_country_cover_change(country.name)).to eq(
        {
          change_km: delimit(change_km),
          change_percentage: change_percentage
        }
      )
    end

    it 'calculates the correct global cover change' do
      expect(habitat.calculate_global_cover_change).to eq(
        { 
          baseline_year: habitat.baseline_year, 
          change_km: change_km, 
          change_percentage: change_percentage, 
          original_total: change_stat.total_value_2010.round(2) 
        }
      )
    end

    it 'returns the correct statistics' do
      expect(habitat.global_stats).to eq({ 
        protected_habitat_cover: global_protected_percentage, 
        total_habitat_cover: global_habitat_cover 
      })
    end

    it 'calculates the global protection' do
      expect(habitat.calculate_global_protection).to eq({ 
        'protected_percentage' => global_protected_percentage, 
        'total_value' => global_habitat_cover  
      })
    end

    it 'retrieves the occurrence of the habitat' do   
      expect(habitat.occurrence(country.id)).to eq('present')
    end
  end
end
