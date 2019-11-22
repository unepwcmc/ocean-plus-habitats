class CreateChangeStats < ActiveRecord::Migration[5.1]
  def change
    create_table :change_stats do |t|
      t.references :habitat, foreign_key: true
      t.references :geo_entity, foreign_key: true
      t.decimal :total_value_1996, null: false, default: 0
      t.decimal :total_value_2007, null: false, default: 0
      t.decimal :total_value_2008, null: false, default: 0
      t.decimal :total_value_2009, null: false, default: 0
      t.decimal :total_value_2010, null: false, default: 0
      t.decimal :total_value_2015, null: false, default: 0
      t.decimal :total_value_2016, null: false, default: 0
      t.integer :baseline_year, null: false, default: 2010
      t.decimal :protected_value, null: false, default: 0
      t.decimal :protected_percentage, null: false, default: 0
      t.timestamps
    end
  end
end
