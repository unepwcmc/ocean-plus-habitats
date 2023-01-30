class AddTotalValueYearsToChangeStat < ActiveRecord::Migration[5.1]
  def change
    add_column :change_stats, :total_value_2017, :decimal, default: 0
    add_column :change_stats, :total_value_2018, :decimal, default: 0
    add_column :change_stats, :total_value_2019, :decimal, default: 0
    add_column :change_stats, :total_value_2020, :decimal, default: 0
  end
end
