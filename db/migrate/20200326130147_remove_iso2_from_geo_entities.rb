class RemoveIso2FromGeoEntities < ActiveRecord::Migration[5.1]
  def change
    remove_column :geo_entities, :iso2, :string
  end
end
