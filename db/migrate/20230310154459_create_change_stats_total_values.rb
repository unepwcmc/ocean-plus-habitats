class CreateChangeStatsTotalValues < ActiveRecord::Migration[5.1]
  def change
    create_table :change_stats_total_values do |t|
      t.integer :change_stat_id
      t.decimal :total_value, default: 0
      t.integer :year

      t.timestamps
    end
  end
end
