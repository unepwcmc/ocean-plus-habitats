require 'csv'

namespace :import do
  desc "Import bounding boxes for countries and regions"
  task :bounding_boxes => [:environment] do
    import_bounding_boxes_for('regionalseas')

    import_bounding_boxes_from_esri
  end

  def import_bounding_boxes_for(geo_entity_type)
    filename = "lib/data/#{geo_entity_type}.csv"

    CSV.foreach(filename, headers: true) do |row|
      name, iso3, bounding_box = [row['country_name'] || row['region'], row['alpha-3'], row['bounding-box']]
      if bounding_box.present? && bounding_box.include?(';')
        geo_entity = GeoEntity.find_by(name: name, iso3: iso3)
        bounding_box = bounding_box.split(';').map { |bb| bb.split(' ').map(&:to_f) }
        geo_entity.update_attributes!(bounding_box: bounding_box)
      end
    end
  end

  def import_bounding_boxes_from_esri
    filename = "lib/data/habitat_presence/habitat_presence_country.csv"

    CSV.foreach(filename, headers: true) do |row|
      actual_name = row['COUNTRY']
      iso3 = row['ISO3']
      geo_entity = GeoEntity.find_by(actual_name: actual_name, iso3: iso3)

      bounding_box = Esri.new.fetch_bounding_box(iso3)
      # ESRI's parsed response still looks like 
      # "extent": {
      #   "xmin": -141.0068664547689,
      #   "ymin": 40.051148997526347,
      #   "xmax": -47.69414702371968,
      #   "ymax": 86.431873132655937,
      # }
      formatted_bbox = format_bbox(bounding_box)

      geo_entity.update_attributes!(bounding_box: formatted_bbox)
    end   
  end

  # This turns bboxes into separated pairs of coordinates (4326)
  def format_bbox(box)
    box.values.each_slice(2).to_a
  end
end
