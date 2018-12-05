class AddWmsUrlToHabitats < ActiveRecord::Migration[5.1]
  def change
    add_column :habitats, :wms_url, :text
  end
end
