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

#Import countries
count = 0
CSV.foreach('lib/data/countries.csv', headers: true) do |row|
  name, iso2, iso3 = [row['name'], row['alpha-2'], row['alpha-3']]
  next if GeoEntity.where(name: name).first
  count += 1 if GeoEntity.create(name: name, iso2: iso2, iso3: iso3)
end
Rails.logger.info("#{count} countries were created successfully!")

count = 0
CSV.foreach('lib/data/regionalseas.csv', headers: true) do |row|
  name, iso2, iso3 = [row['name'], nil, nil]
  next if GeoEntity.where(name: name).first
  countries_iso_codes = row['iso3'].split('/')
  new_region = GeoEntity.new(name: name, iso2: iso2, iso3: iso3)
  if new_region.save
    count+=1
    countries_iso_codes.each do |country_iso|
      country_id = GeoEntity.find_by(iso3: country_iso).id
      GeoRelationship.create(country_id: country_id, region_id: new_region.id)
    end
  end
end
Rails.logger.info("#{count} regions were created successfully!")
