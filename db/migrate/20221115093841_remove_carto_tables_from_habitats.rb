class RemoveCartoTablesFromHabitats < ActiveRecord::Migration[5.1]
  def change
    remove_column :habitats, :point_table, :string
    remove_column :habitats, :poly_table, :string
  end
end
