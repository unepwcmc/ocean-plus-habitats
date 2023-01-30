FactoryBot.define do
  factory :change_stat do
    protected_value { |n| n }
    baseline_year { 2010 }
    total_value_1996 { 0.05 }
    total_value_2007 { 0.15 }
    total_value_2008 { 0.25 }
    total_value_2009 { 0.35 }
    total_value_2010 { 0.5 }
    total_value_2015 { 0.7 }
    total_value_2016 { 0.9 }
    total_value_2017 { 0.9 }
    total_value_2018 { 0.9 }
    total_value_2019 { 0.9 }
    total_value_2020 { 0.95 }
    protected_percentage { 50.0 }
    association :geo_entity, factory: :country_with_mangroves
    association :habitat, factory: :mangroves
  end
end
