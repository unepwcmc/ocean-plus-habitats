FactoryBot.define do
  factory :habitat do
    name { 'coralreefs' }
    title { 'Warm-water corals' }
    theme { 'orange' }
    global_coverage { 0 }
    protected_percentage { 0 }
    wms_url { 'dummy URL' }
  end
end
