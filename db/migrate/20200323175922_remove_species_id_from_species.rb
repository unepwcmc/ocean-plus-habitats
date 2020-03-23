class RemoveSpeciesIdFromSpecies < ActiveRecord::Migration[5.1]
  def change
    remove_column :species, :species_id, :integer
  end
end
