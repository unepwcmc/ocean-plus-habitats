module FactoryBotHelpers
  def self.geo_entity_name(n, is_region)
    is_region ? "Region #{n}" : "Country #{n}"
  end

  def self.geo_entity_iso(is_region)
    is_region ? nil : 'ABC'
  end
end

FactoryBot.define do
  factory :geo_entity, aliases: [:country, :region] do
    sequence(:name) { |n| FactoryBotHelpers.geo_entity_name(n, is_region) }
    sequence(:actual_name) { |n| FactoryBotHelpers.geo_entity_name(n, is_region) }
    iso3 { FactoryBotHelpers.geo_entity_iso(is_region) }
    bounding_box { [[-70.41666666583112, 12.150501231616646], [-68.87016907252374, 15.300000001018887]] }

    after(:create) do |geo_entity|
      geo_entity.countries << create_list(:country, 2) if geo_entity.is_region
    end

    factory :country_with_mangroves do
      name { 'Country with mangroves' }
      actual_name { 'Coüntry with mangroves' }

      factory :country_with_mangrove_change_stat do
        after(:create) do |country_with_mangroves, _evaluator|
          mangroves = create(:mangroves)
          create(:change_stat, habitat: mangroves, geo_entity: country_with_mangroves)

          country_with_mangroves.reload
        end
      end
    end

    factory :data_deficient_country do
      transient do
        data_deficient_habitat { FactoryBot.create(:coralreefs) }

        habitats { 
          [
            FactoryBot.create(:coldcorals), 
            FactoryBot.create(:mangroves), 
            FactoryBot.create(:saltmarshes), 
            FactoryBot.create(:seagrasses)
          ] 
        }
      end

      after(:create) do |geo_entity, evaluator|
        create(:stat_without_data, habitat: evaluator.data_deficient_habitat, geo_entity: geo_entity)
        
        evaluator.habitats.each do |habitat|
          create(:geo_entity_stat, habitat: habitat, geo_entity: geo_entity)
        end

        geo_entity.reload
      end
    end    
  end
end
