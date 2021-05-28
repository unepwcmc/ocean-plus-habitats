FactoryBot.define do
  factory :habitat do
    factory :coralreefs do
      name { 'coralreefs' }
      title { 'Warm-water corals' }
      theme { 'orange' }
      global_coverage { 0 }
      protected_percentage { 0 }
      wms_url { 'dummy URL' }
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

    transient do
      species_count { 5 }
    end

    after(:create) do |habitat, evaluator|
      country = create(:geo_entity)
      create(:geo_entity_stat, habitat: habitat, geo_entity: country)
      create(:global_change_stat, habitat: habitat)
      create_list(:species, evaluator.species_count, habitat: habitat)

      habitat.reload
    end
  end
end
