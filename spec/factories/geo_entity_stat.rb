FactoryBot.define do
  factory :geo_entity_stat do
    factory :country_geo_entity_stat do
      protected_value { 38.0 }
      total_value { 100.0 }
      protected_percentage { 38.0 }
      occurrence { 2 }
      coastal_coverage { 20.0 }
    end

    factory :habitat_with_stats do
      transient do 
        geo_entity_stats_count { 3 }
      end
  
      after(:create) do |habitat, evaluator|
        create_list(:country_geo_entity_stat, evaluator.geo_entity_stats_count)
  
        habitat.reload
      end
    end
  end
end
