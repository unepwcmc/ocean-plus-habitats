habitats_config = YAML.load(File.open("#{Rails.root}/config/habitats.yml", 'r'))

habitats_config['habitats'].each do |name, data|
  if Habitat.where(name: data['name']).present?
    Habitat.where(name: data['name']).first.update_attributes(data)
  end
  Habitat.create(data)
  Rails.logger.info "#{name.capitalize} habitat created!"
end

# Commented as we are temporarily using static data
#Habitat.all.each do |habitat|
#  habitat.calculate_global_coverage
#  Rails.logger.info("Global coverage calculate for #{habitat.name}!")
#end

#Import countries
count = 0
CSV.foreach('lib/data/countries.csv', headers: true) do |row|
  name, iso2, iso3 = [row['name'], row['alpha-2'], row['alpha-3']]
  next if Country.where(name: name).first
  count += 1 if Country.create(name: name, iso2: iso2, iso3: iso3)
end
Rails.logger.info("#{count} countries were created successfully!")
