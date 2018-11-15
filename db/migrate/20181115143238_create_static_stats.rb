class CreateStaticStats < ActiveRecord::Migration[5.1]
  def change
    create_table :static_stats do |t|
      t.references :habitat, foreign_key: true
      t.references :country, foreign_key: true
      t.decimal :protected_value, null: false, default: 0
      t.decimal :total_value, null: false, default: 0
      t.decimal :protected_percentage, null: false, default: 0

      t.timestamps
    end
  end
end
