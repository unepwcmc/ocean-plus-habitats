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

    tasks = %w(countries regions sources country_citations prebakedstats coastalstats new_redlist_data)
    tasks.each do |t|
      task_name = "import:#{t}"

      p "Running #{task_name}..."
      Rake::Task[task_name].invoke
    end
  end
end
