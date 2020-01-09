class AddBoundingBoxToGeoEntities < ActiveRecord::Migration[5.1]
  def change
    add_column :geo_entities, :bounding_box, :integer, array: true, default: []
    add_index  :geo_entities, :bounding_box, using: :gin
  end
end
