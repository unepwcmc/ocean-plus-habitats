class CreateGlobalChangeStats < ActiveRecord::Migration[5.1]
  def change
    create_table :global_change_stats do |t|
      t.references :habitat, foreign_key: true
      t.decimal :percentage_lost, null: false, default: 0
      t.decimal :lower_bound_percentage, null: false, default: 0
      t.decimal :upper_bound_percentage, null: false, default: 0
      t.integer :baseline_year, null: false
      t.integer :recent_year, null: false
      t.timestamps
    end
  end
end
