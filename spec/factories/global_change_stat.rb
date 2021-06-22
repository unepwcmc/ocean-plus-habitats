FactoryBot.define do
  factory :global_change_stat do
    percentage_lost { 0.5e2 }
    baseline_year { 1870 }
    recent_year { 2019 }
    association :habitat
  end
end
