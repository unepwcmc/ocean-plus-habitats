FactoryBot.define do
  factory :habitat do
    factory :coralreefs do
      name { 'coralreefs' }
      title { 'Warm-water corals' }
      theme { 'orange' }
      global_coverage { 0 }
      protected_percentage { 0 }
      total_area { 0 }
      protected_area { 0 }
      wms_url { 'dummy URL' }
      total_area { 149886.974126351 }
      protected_area { 67498.1537285504 }
    end

    factory :coldcorals do
      name { 'coldcorals' }
      title { 'Cold-water corals' }
      theme { 'orange' }
      global_coverage { 0 }
      protected_percentage { 0 }
      total_area { 0 }
      protected_area { 0 }
      wms_url { 'dummy URL' }
      total_area { 15336.9752787556 }
      protected_area { 4511.04992438828 }
    end

    factory :saltmarshes do
      name { 'saltmarshes' }
      title { 'Saltmarshes' }
      theme { 'orange' }
      global_coverage { 0 }
      protected_percentage { 0 }
      total_area { 0 }
      protected_area { 0 }
      wms_url { 'dummy URL' }
      total_area { 224435.075089817 }
      protected_area { 111454.965592792 }
    end

    factory :seagrasses do
      name { 'seagrasses' }
      title { 'Seagrasses' }
      theme { 'orange' }
      global_coverage { 0 }
      protected_percentage { 0 }
      total_area { 0 }
      protected_area { 0 }
      wms_url { 'dummy URL' }
      total_area { 314001.940552758 }
      protected_area { 83689.7720939699 }
    end

    factory :mangroves do
      name { 'mangroves' }
      title { 'Mangroves' }
      theme { 'orange' }
      global_coverage { 0 }
      protected_percentage { 0 }
      total_area { 0 }
      protected_area { 0 }
      wms_url { 'dummy URL' }
      total_area { 100 }
      protected_area { 38 }

      after(:create) do |mangroves, _evaluator|
        country_with_mangroves = create(:country_with_mangroves)
        create(:change_stat, habitat: mangroves, geo_entity: country_with_mangroves)

        mangroves.reload
      end
    end

    transient do 
      species_count { 20 }
    end

    after(:create) do |habitat, evaluator|
      create_list(:species, evaluator.species_count, habitat: habitat)

      habitat.reload
    end
  end
end
