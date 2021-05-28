FactoryBot.define do
  factory :geo_entity do
    name { 'Country' }
    actual_name { 'Coüntry' }
    iso3 { 'ABC' }
    bounding_box { [[-70.41666666583112, 12.150501231616646], [-68.87016907252374, 15.300000001018887]] }

    factory :country_with_mangroves do
      name { 'Country with mangroves' }

      factory :country_with_mangrove_change_stat do
        after(:create) do |country_with_mangroves, _evaluator|
          mangroves = create(:mangroves)
          create(:change_stat, habitat: mangroves, geo_entity: country_with_mangroves)

          country_with_mangroves.reload
        end
      end
    end
  end
end
