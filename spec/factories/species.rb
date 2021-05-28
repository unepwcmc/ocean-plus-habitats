FactoryBot.define do 
  factory :species do
    common_name { ('a'..'z').to_a.shuffle.join }
    scientific_name { ('a'..'z').to_a.shuffle.join }
    redlist_status { 'LC' }
    url { 'dummy URL' }
    habitat
  end 
end