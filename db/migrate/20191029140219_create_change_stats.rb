class CreateChangeStats < ActiveRecord::Migration[5.1]
  def change
    create_table :change_stats do |t|
      t.references :habitat, foreign_key: true
      t.references :country, foreign_key: true
      t.decimal :total_value_2007, null: false, default: 0
      t.decimal :total_value_2008, null: false, default: 0
      t.decimal :total_value_2009, null: false, default: 0
      t.decimal :total_value_2010, null: false, default: 0
      t.decimal :total_value_2015, null: false, default: 0
      t.integer :baseline_year, null: false, default: 2010

      t.timestamps
    end
  end
end
