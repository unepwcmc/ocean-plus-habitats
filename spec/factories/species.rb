FactoryBot.define do 
  factory :species do
    common_name { ('a'..'z').to_a.shuffle.join }
    scientific_name { ('a'..'z').to_a.shuffle.join }
    redlist_status { 'LC' }
    url { 'dummy URL' }
    association :habitat
    
    factory :defined_species do
      factory :least_concern_species do 
        common_name { Faker::Creature::Animal.name }
        scientific_name { "#{common_name} muscaria" }
        redlist_status { 'LC' }
      end

      factory :near_threatened_species do
        common_name { Faker::Creature::Animal.name }
        scientific_name { "Mammoth mammothus #{common_name}" }
        redlist_status { 'NT' }
      end

      factory :vulnerable_species do
        common_name { Faker::Creature::Animal.name }
        scientific_name { "#{common_name} horribilis" }
        redlist_status { 'VU' }
      end

      factory :endangered_species do
        common_name { Faker::Creature::Animal.name }
        scientific_name { "#{common_name} sharkus" }
        redlist_status { 'EN' }
      end

      factory :critically_endangered_species do
        common_name { Faker::Creature::Animal.name }
        scientific_name { "Homo sapiens #{common_name}" }
        redlist_status { 'CR' }
      end
    end
  end 
end