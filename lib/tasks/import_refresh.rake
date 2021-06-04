namespace :import do
  desc "Delete and recreate records"
  task :refresh => [:environment] do
    models =  %w(
      GeoEntityStat ChangeStat GeoRelationship CoastalStat GeoEntity
      GeoEntitiesSpecies Species GeoEntityStatsSources Source CountryCitation
    )

    models.each do |m|
      p "Deleting #{m}..."
      m.constantize.send(:delete_all)
    end

    tasks = %w(countries regions prebakedstats new_redlist_data coastalstats global_change sources country_citations bounding_boxes)
    tasks.each do |t|
      task_name = "import:#{t}"

      p "Running #{task_name}..."
      Rake::Task[task_name].invoke
    end

    Rake::Task["generate:national_csvs"].invoke
  end
end
