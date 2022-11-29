class AddIsRegionToGeoEntity < ActiveRecord::Migration[5.1]
  def change
    add_column :geo_entities, :is_region, :boolean, default: false

    reversible do |change|
      change.up do
        GeoEntity.all.each do |ge|
          ge.update(is_region: true) if ge.iso3.nil?
        end
      end
    end
  end
end
