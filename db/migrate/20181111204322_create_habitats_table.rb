class CreateHabitatsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :habitats do |t|
      t.string :name, null: false, default: ''
      t.string :title, null: false, default: ''
      t.string :theme, null: false, default: ''
      t.string :poly_table
      t.string :point_table
      t.integer :global_coverage, null: false, default: 0
      t.integer :protected_percentage, null: false, default: 0

      t.timestamps
    end
  end
end
