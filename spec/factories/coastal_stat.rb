FactoryBot.define do
  factory :coastal_stat do
    total_coast_length { rand(0.5e1..0.3e6) }
    multiple_habitat_length { total_coast_length }
    association :geo_entity
  end
end