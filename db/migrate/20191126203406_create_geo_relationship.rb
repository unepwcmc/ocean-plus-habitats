class CreateGeoRelationship < ActiveRecord::Migration[5.1]
  def change
    create_table :geo_relationships do |t|
      t.references :country, foreign_key: { to_table: 'geo_entities' }
      t.references :region, foreign_key: { to_table: 'geo_entities' }
    end
  end
end
