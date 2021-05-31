FactoryBot.define do
  factory :habitat do
    factory :coralreefs do
      name { 'coralreefs' }
      title { 'Warm-water corals' }
      theme { 'orange' }
      global_coverage { 0 }
      protected_percentage { 0 }
      wms_url { 'dummy URL' }

      factory :habitat_with_species do
        transient do 
          species_count { 20 }
        end
  
        after(:create) do |coralreefs, evaluator|
          create_list(:species, evaluator.species_count, habitat: coralreefs)
  
          coralreefs.reload
        end
      end
    end

    factory :coldcorals do
      name { 'coldcorals' }
      title { 'Cold-water corals' }
      theme { 'orange' }
      global_coverage { 0 }
      protected_percentage { 0 }
      wms_url { 'dummy URL' }
    end

    factory :saltmarshes do
      name { 'saltmarshes' }
      title { 'Saltmarshes' }
      theme { 'orange' }
      global_coverage { 0 }
      protected_percentage { 0 }
      wms_url { 'dummy URL' }
    end

    factory :seagrasses do
      name { 'seagrasses' }
      title { 'Seagrasses' }
      theme { 'orange' }
      global_coverage { 0 }
      protected_percentage { 0 }
      wms_url { 'dummy URL' }
    end

    factory :mangroves do
      name { 'mangroves' }
      title { 'Mangroves' }
      theme { 'orange' }
      global_coverage { 0 }
      protected_percentage { 0 }
      wms_url { 'dummy URL' }

      after(:create) do |mangroves, _evaluator|
        country_with_mangroves = create(:country_with_mangroves)
        create(:change_stat, habitat: mangroves, geo_entity: country_with_mangroves)

        mangroves.reload
      end
    end
  end
end
