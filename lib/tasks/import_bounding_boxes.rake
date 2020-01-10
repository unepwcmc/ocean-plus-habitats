require 'csv'

namespace :import do
  desc "Import bounding boxes for countries and regions"
  task :bounding_boxes => [:environment] do
    %w(countries regionalseas).each do |geo_entity_type|
      import_bounding_boxes_for(geo_entity_type)
    end
  end

  def import_bounding_boxes_for(geo_entity_type)
    filename = "lib/data/#{geo_entity_type}.csv"
    CSV.foreach(filename, headers: true) do |row|
      name, iso2, iso3, bounding_box = [row['name'], row['alpha-2'], row['alpha-3'], row['bounding-box']]
      if bounding_box.present? && bounding_box.include?(';')
        geo_entity = GeoEntity.find_by(name: name, iso2: iso2, iso3: iso3)
        bounding_box = bounding_box.split(';').map { |bb| bb.split(' ').map(&:to_f) }
        geo_entity.update_attributes!(bounding_box: bounding_box)
      end
    end
  end
end
