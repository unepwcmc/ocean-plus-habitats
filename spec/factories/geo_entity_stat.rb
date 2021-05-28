FactoryBot.define do
  factory :geo_entity_stat do
    protected_value { 38.0 }
    total_value { 100.0 }
    protected_percentage { 38.0 }
    occurrence { 2 }
    coastal_coverage { 20.0 }
    association :geo_entity
    association :habitat
  end
end
