FactoryBot.define do
  factory :geo_entity_stat do
    protected_value { 38.0 }
    total_value { 100.0 }
    protected_percentage { 38.0 }
    occurrence { rand(3) }
    coastal_coverage { 20.0 }
    association :geo_entity
    association :habitat

    factory :present_stat do
      occurrence { 2 }
    end

    factory :stat_without_data do 
      protected_value { nil }
      total_value { nil }
      protected_percentage { nil }
      occurrence { 2 }
    end
  end
end
