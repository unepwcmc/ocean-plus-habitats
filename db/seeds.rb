%w(habitats countries regions prebakedstats new_redlist_data coastalstats global_change 
  sources country_citations habitat_sources_per_country bounding_boxes).each do |import_type|
  Rake::Task["import:#{import_type}"].invoke
end

Rake::Task["generate:national_csvs"].invoke
