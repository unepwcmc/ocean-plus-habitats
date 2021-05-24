class AddActualNameToGeoEntity < ActiveRecord::Migration[5.1]
  def change
    add_column :geo_entities, :actual_name, :string
  end
end
