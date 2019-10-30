class CreateRegionalStats < ActiveRecord::Migration[5.1]
  def change
    create_table :regional_stats do |t|
      t.references :habitat, foreign_key: true
      t.references :country, foreign_key: true
      t.decimal :total_area, null: false, default: 0
      t.decimal :total_points, null: false, default: 0
      t.decimal :total_protected, null: false, default: 0
      t.decimal :protected_percentage, null: false, default: 0

      t.timestamps
    end
  end
end
