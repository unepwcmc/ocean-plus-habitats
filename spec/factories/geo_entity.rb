FactoryBot.define do
  factory :geo_entity do
    name { 'Aruba' }
   
    factory :country do 
      iso3 { 'ABW' }
      bounding_box { '999 9999; 999 99999' }
      actual_name { 'Aruba' }

      factory :country_with_stats do
        transient do 
          geo_entity_stats_count { 4 }
        end

        
      end
    end
  
    factory :region do 

    end
  end
end
