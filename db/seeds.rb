habitats_config = YAML.load(File.open("#{Rails.root}/config/habitats.yml", 'r'))

habitats_config['habitats'].each do |name, data|
  Habitat.where(name: data['name']).first_or_create do |habitat|
    habitat.update_attributes(data)
  end
  Rails.logger.info "#{name.capitalize} habitat created!"
end

# Commented as we are temporarily using static data
#Habitat.all.each do |habitat|
#  habitat.calculate_global_coverage
#  Rails.logger.info("Global coverage calculate for #{habitat.name}!")
#end

%w(countries regions prebakedstats redlist_data).each do |import_type|
  Rake::Task["import:#{import_type}"].invoke
end
