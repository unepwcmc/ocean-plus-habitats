class CreateCoastalStatsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :coastal_stats do |t|
      t.references :geo_entity
      t.decimal :total_coast_length, default: 0
      t.decimal :multiple_habitat_length, default: 0

      t.timestamps
    end
  end
end
