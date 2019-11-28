class AddRedlistUrlToSpecies < ActiveRecord::Migration[5.1]
  def change
    add_column :species, :url, :string
  end
end
