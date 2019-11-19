class CreateSpecies < ActiveRecord::Migration[5.1]
  def change
    create_table :species do |t|
      t.integer :species_id, null: false
      t.string :scientific_name, null: false
      t.string :common_name
      t.string :redlist_status, null: false

      t.references :habitat
      t.timestamps
    end
  end
end
