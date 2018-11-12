habitats_config = YAML.load(File.open("#{Rails.root}/config/habitats.yml", 'r'))

habitats_config['habitats'].each do |name, data|
  next if Habitat.where(name: data['name']).present?
  Habitat.create(data)
  Rails.logger.info "#{name.capitalize} habitat created!"
end

Habitat.all.each do |habitat|
  habitat.calculate_global_coverage
  Rails.logger.info("Global coverage calculate for #{habitat.name}!")
end
