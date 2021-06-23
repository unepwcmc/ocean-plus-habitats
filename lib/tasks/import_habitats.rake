namespace :import do
  desc "import CSV data into database"
  task :habitats, [:csv_file] => [:environment] do
    habitats_config = YAML.load(File.open("#{Rails.root}/config/habitats.yml", 'r'))

    habitats_config['habitats'].each do |name, data|
      Habitat.where(name: data['name']).first_or_create do |habitat|
        habitat.update_attributes(data)
      end
      Rails.logger.info "#{name.capitalize} habitat created!"
    end
  end
end