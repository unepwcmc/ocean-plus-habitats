namespace :migrate do
  desc 'Migrate total values from change stats table to new table'
    task :change_stats_total_values => [:environment] do

    	YEARS = [1996,2007,2008,2009,2010,2015,2016]

        ch = ChangeStat.all
        ch.each do |c|
          YEARS.each do |year|
            total_value = c.send("total_value_#{year}")
            c.change_stats_total_values.create(total_value: total_value, year: year)
          end
        end

        puts "Data migration complete"
    end
end